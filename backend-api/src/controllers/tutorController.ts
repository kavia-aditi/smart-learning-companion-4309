import { Request, Response, NextFunction } from 'express';
import { db } from '../models/db';
import { TutorChatSchema } from '../utils/validation';
import { ChatMessage } from '../models/types';
import OpenAI from 'openai';

// Initialize OpenAI client lazily to avoid boot failure without key.
// We will check presence during request handling.
let openaiClient: OpenAI | null = null;
function getOpenAIClient(): OpenAI {
  if (!openaiClient) {
    const apiKey = process.env.OPENAI_API_KEY;
    if (!apiKey) {
      // Return a dummy client placeholder; actual check happens in handler.
      throw new Error('OPENAI_API_KEY missing');
    }
    openaiClient = new OpenAI({ apiKey });
  }
  return openaiClient;
}

// PUBLIC_INTERFACE
export const chatWithTutor = async (req: Request, res: Response, _next: NextFunction) => {
  /**
   * Tutor chat endpoint backed by OpenAI. Validates input, trims history,
   * builds a concise system prompt with optional lesson/quiz context, and
   * returns a single assistant message. Falls back gracefully on errors.
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
   * Returns: { reply: string, model: string, usage?: { prompt_tokens?, completion_tokens?, total_tokens? } }
   */
  const parsed = TutorChatSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'Invalid payload', details: parsed.error.flatten() });
  }

  const { userId, message, context } = parsed.data;

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

  const model = process.env.OPENAI_MODEL || 'gpt-4o-mini-2024-07-18';

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

  // Fail fast if missing API key at call time
  if (!process.env.OPENAI_API_KEY) {
    const fallback = fallbackHeuristic({ role: 'user', content: currentMessage }, lessonTitle, context?.lessonId, context?.quizId);
    return res.status(503).json({
      error: true,
      message: 'Tutor is temporarily unavailable',
      reply: fallback,
      model: 'local-heuristic',
    });
  }

  try {
    const client = getOpenAIClient();

    const completion = await client.chat.completions.create({
      model,
      messages: chatMessages,
      temperature: 0.2,
    });

    const content = completion.choices?.[0]?.message?.content?.trim() || '';
    const replyText =
      content ||
      fallbackHeuristic({ role: 'user', content: currentMessage }, lessonTitle, context?.lessonId, context?.quizId);

    // Minimal metadata logging (avoid logging user content in production)
    if (process.env.NODE_ENV !== 'production') {
      // eslint-disable-next-line no-console
      console.log('[tutor.chat] model=%s usage=%o', model, completion.usage || {});
    } else {
      // eslint-disable-next-line no-console
      console.log('[tutor.chat] model=%s', model);
    }

    return res.json({
      reply: replyText,
      model,
      usage: completion.usage
        ? {
            prompt_tokens: completion.usage.prompt_tokens,
            completion_tokens: completion.usage.completion_tokens,
            total_tokens: completion.usage.total_tokens,
          }
        : undefined,
    });
  } catch (err: any) {
    // Log minimal error metadata
    // eslint-disable-next-line no-console
    console.error('[tutor.chat] OpenAI error', { name: err?.name, code: err?.code, status: err?.status });

    const fallback = fallbackHeuristic({ role: 'user', content: currentMessage }, lessonTitle, context?.lessonId, context?.quizId);
    return res.status(503).json({
      error: true,
      message: 'Tutor is temporarily unavailable',
      reply: fallback,
      model: 'local-heuristic',
    });
  }
};

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
