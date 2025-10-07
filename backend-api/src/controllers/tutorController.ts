import { Request, Response, NextFunction } from 'express';
import axios from 'axios';
import OpenAI from 'openai';
import { db } from '../models/db';
import { TutorChatSchema } from '../utils/validation';
import { ChatMessage } from '../models/types';

// Initialize OpenAI client lazily to avoid boot failure without key.
// We will check presence during request handling.
let openaiClient: OpenAI | null = null;
function getOpenAIClient(): OpenAI {
  if (!openaiClient) {
    const apiKey = process.env.OPENAI_API_KEY;
    if (!apiKey) {
      throw new Error('OPENAI_API_KEY missing');
    }
    openaiClient = new OpenAI({ apiKey });
  }
  return openaiClient;
}

// Simple rules-based fallback tutor logic leveraging local data when available
function fallbackHeuristic(
  lastUser: ChatMessage | undefined,
  lessonTitle?: string,
  lessonId?: string,
  quizId?: string
): string {
  const baseIntro = lessonTitle ? `You're studying "${lessonTitle}". ` : '';
  const prompt = (lastUser?.content || '').toLowerCase();

  if (prompt.includes('explain')) {
    return `${baseIntro}Quick tip: Focus on the core idea, its purpose, and a simple example. Try summarizing it in your own words.`;
  }
  if (prompt.includes('example')) {
    return `${baseIntro}Example idea: Walk through inputs → steps → result. Create a similar example to practice.`;
  }
  if (prompt.includes('quiz')) {
    const relatedQuiz =
      (lessonId && db.quizzes.find((q) => q.lessonId === lessonId)) || (quizId && db.quizzes.find((q) => q.id === quizId));
    if (relatedQuiz) {
      return `${baseIntro}Try the quiz "${relatedQuiz.title}" to test your understanding. Ready to review answers together?`;
    }
    return `${baseIntro}I don't see a related quiz, but checking the quizzes list for this lesson could help.`;
  }

  if (lessonTitle) {
    return `${baseIntro}What would you like next—definitions, a quick example, or a short practice question?`;
  }

  return `How can I help? I can explain topics, provide examples, or suggest a quick practice question.`;
}

// Bounded history: keep last 10 exchanges (20 turns)
function pruneHistory(history: ChatMessage[]) {
  const max = 20; // 10 exchanges = 20 turns
  if (history.length > max) {
    return history.slice(history.length - max);
  }
  return history;
}

// PUBLIC_INTERFACE
export const chatWithTutor = async (req: Request, res: Response, _next: NextFunction) => {
  /**
   * Tutor chat endpoint with provider-based AI:
   * - AI_PROVIDER: 'ollama' (default) | 'openai'
   * - OLLAMA_BASE_URL, OLLAMA_MODEL (for ollama)
   * - OPENAI_API_KEY, OPENAI_MODEL, OPENAI_BASE_URL (for openai)
   *
   * Validates input, trims history, builds a concise system prompt with optional lesson/quiz context.
   * Falls back to local heuristic if provider unavailable.
   *
   * Payload:
   * {
   *   message: string,
   *   userId?: string,
   *   context?: {
   *     lessonId?: string,
   *     quizId?: string,
   *     history?: {role:'user'|'assistant'|'system', content:string}[]
   *   }
   * }
   *
   * Returns: { reply: string, model: string, provider: string, usage?: {...} }
   */
  const parsed = TutorChatSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'Invalid payload', details: parsed.error.flatten() });
  }

  const { message, context } = parsed.data;

  // Validate non-empty current message
  const currentMessage = (message || '').trim();
  if (!currentMessage) {
    return res.status(400).json({ error: 'Invalid payload', details: { message: 'message must be a non-empty string' } });
  }

  // Start building history and bound it to the last 10 entries
  const history: ChatMessage[] = (context?.history || []).slice(-10);

  // Build optional lesson context
  let lessonTitle: string | undefined;
  if (context?.lessonId) {
    const lesson = db.lessons.find((l) => l.id === context.lessonId);
    lessonTitle = lesson?.title;
  }

  // System prompt to set tone and guidance
  const systemLines: string[] = [
    'You are a helpful AI micro-tutor.',
    'Keep answers concise and step-by-step.',
    'Reference the lesson context when provided.',
    'Offer brief encouragement and optionally a single follow-up question.',
  ];
  if (lessonTitle) {
    systemLines.push(`Lesson context title: "${lessonTitle}".`);
  }
  if (context?.quizId) {
    systemLines.push(`Related quizId: ${context.quizId}. If relevant, suggest trying the quiz after explanation.`);
  }
  const systemPrompt = systemLines.join(' ');

  // Assemble messages for the model
  const chatMessages: { role: 'system' | 'user' | 'assistant'; content: string }[] = [
    { role: 'system', content: systemPrompt },
    ...history.map((m) => ({ role: m.role, content: m.content })),
    { role: 'user', content: currentMessage },
  ];

  const provider = (process.env.AI_PROVIDER || 'ollama').toLowerCase();

  // Provider-specific calls
  async function callOllama(): Promise<{ reply: string; model: string }> {
    const base = (process.env.OLLAMA_BASE_URL || 'http://ollama:11434').replace(/\/+$/, '');
    const model = process.env.OLLAMA_MODEL || 'llama3:instruct';
    const payload = {
      model,
      messages: chatMessages.map((m) => ({ role: m.role, content: m.content })),
      stream: false,
      options: {
        temperature: 0.7,
      },
    };
    const url = `${base}/api/chat`;
    const resp = await axios.post(url, payload, {
      timeout: 60000,
      headers: { 'Content-Type': 'application/json' },
    });
    const data = resp.data;
    const content: string | undefined = data?.message?.content;
    if (!content || typeof content !== 'string') {
      throw new Error('Invalid Ollama response: missing assistant content');
    }
    return { reply: content.trim(), model };
  }

  async function callOpenAI(): Promise<{ reply: string; model: string; usage?: any }> {
    const apiKey = process.env.OPENAI_API_KEY;
    const model = process.env.OPENAI_MODEL || 'gpt-4o-mini-2024-07-18';
    const base = (process.env.OPENAI_BASE_URL || 'https://api.openai.com').replace(/\/+$/, '');

    if (!apiKey) {
      throw new Error('OPENAI_API_KEY is required when AI_PROVIDER=openai');
    }

    const client = getOpenAIClient();

    const completion = await client.chat.completions.create({
      model,
      messages: chatMessages,
      temperature: 0.7,
      stream: false as any,
    });

    const content = completion.choices?.[0]?.message?.content?.trim();
    if (!content) {
      throw new Error('Invalid OpenAI response: missing assistant content');
    }

    return {
      reply: content,
      model,
      usage: completion.usage
        ? {
            prompt_tokens: completion.usage.prompt_tokens,
            completion_tokens: completion.usage.completion_tokens,
            total_tokens: completion.usage.total_tokens,
          }
        : undefined,
    };
  }

  try {
    if (provider === 'openai') {
      const { reply, model, usage } = await callOpenAI();
      return res.json({ reply, model, provider, usage });
    }

    // default to ollama
    const { reply, model } = await callOllama();
    return res.json({ reply, model, provider });
  } catch (err: any) {
    // eslint-disable-next-line no-console
    console.error('[tutor.chat] provider error', { provider, name: err?.name, code: err?.code, status: err?.status });

    const reply = fallbackHeuristic({ role: 'user', content: currentMessage }, lessonTitle, context?.lessonId, context?.quizId);
    return res.status(503).json({
      error: true,
      message: 'Tutor is temporarily unavailable',
      reply,
      model: 'local-heuristic',
      provider,
    });
  }
};
