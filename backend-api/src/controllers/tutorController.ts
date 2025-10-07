import { Request, Response, NextFunction } from 'express';
import { db } from '../models/db';
import { TutorChatSchema } from '../utils/validation';
import { ChatMessage } from '../models/types';

// PUBLIC_INTERFACE
export const chatWithTutor = (req: Request, res: Response, _next: NextFunction) => {
  /** AI Tutor chat stub: heuristic response based on last user message and optional context. */
  const parsed = TutorChatSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'Invalid payload', details: parsed.error.flatten() });
  }

  const { userId, messages, context } = parsed.data;
  const lastUser = [...messages].reverse().find((m) => m.role === 'user');

  let lessonTitle: string | undefined;
  if (context?.lessonId) {
    const lesson = db.lessons.find((l) => l.id === context.lessonId);
    lessonTitle = lesson?.title;
  }

  const responseText = buildHeuristicResponse(lastUser, lessonTitle, context?.lessonId, context?.quizId);

  const reply: ChatMessage = {
    role: 'assistant',
    content: responseText
  };

  // TODO: Integrate with OpenAI using OPENAI_API_KEY for real responses in the future.

  return res.json({
    userId,
    messages: [...messages, reply],
    reply
  });
};

function buildHeuristicResponse(
  lastUser: ChatMessage | undefined,
  lessonTitle?: string,
  lessonId?: string,
  quizId?: string
): string {
  const baseIntro = lessonTitle ? `You're studying "${lessonTitle}". ` : '';
  const prompt = (lastUser?.content || '').toLowerCase();

  if (prompt.includes('explain')) {
    return `${baseIntro}Here's a quick explanation: Focus on the core concept, understand its purpose, and review examples to see it in action. Try summarizing it in your own words.`;
  }
  if (prompt.includes('example')) {
    return `${baseIntro}Example: Consider a simple scenario where the concept is applied step-by-step. Identify inputs, the transformation, and the result. Practice by creating a similar example.`;
  }
  if (prompt.includes('quiz')) {
    const relatedQuiz =
      (lessonId && db.quizzes.find((q) => q.lessonId === lessonId)) || (quizId && db.quizzes.find((q) => q.id === quizId));
    if (relatedQuiz) {
      return `${baseIntro}I suggest trying the quiz "${relatedQuiz.title}" to test your understanding. When you're ready, ask me to review your answers.`;
    }
    return `${baseIntro}I don't see a related quiz, but you can search the quizzes list for this lesson.`;
  }

  if (lessonTitle) {
    return `${baseIntro}What part would you like to dive deeper into—definitions, examples, or a quick practice quiz?`;
  }

  return `How can I help you learn more effectively? I can explain topics, provide examples, or suggest a quiz.`;
}
