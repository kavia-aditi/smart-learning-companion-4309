import { Request, Response, NextFunction } from 'express';
import { db } from '../models/db';
import { SubmitQuizSchema } from '../utils/validation';

// PUBLIC_INTERFACE
export const getQuizzesByLesson = (req: Request, res: Response, _next: NextFunction) => {
  /** List quizzes by lessonId query parameter. */
  const { lessonId } = req.query as { lessonId?: string };
  if (!lessonId) {
    return res.status(400).json({ error: 'lessonId query parameter is required' });
  }
  const quizzes = db.quizzes.filter((q) => q.lessonId === lessonId);
  return res.json({ quizzes });
};

// PUBLIC_INTERFACE
export const submitQuiz = (req: Request, res: Response, _next: NextFunction) => {
  /** Submit quiz answers and return score with per-question feedback. */
  const { quizId } = req.params;
  const parseResult = SubmitQuizSchema.safeParse(req.body);
  if (!parseResult.success) {
    return res.status(400).json({ error: 'Invalid payload', details: parseResult.error.flatten() });
  }

  const { answers } = parseResult.data;

  const quiz = db.quizzes.find((q) => q.id === quizId);
  if (!quiz) {
    return res.status(404).json({ error: 'Quiz not found' });
  }

  const questionMap = new Map(quiz.questions.map((q) => [q.id, q]));
  let correctCount = 0;

  const feedback = answers.map((a) => {
    const q = questionMap.get(a.questionId);
    if (!q) {
      return {
        questionId: a.questionId,
        correct: false,
        correctOptionId: null as string | null,
        explanation: 'Unknown question'
      };
    }
    const isCorrect = q.correctOptionId === a.answer;
    if (isCorrect) correctCount += 1;
    return {
      questionId: q.id,
      correct: isCorrect,
      correctOptionId: q.correctOptionId,
      explanation: isCorrect ? 'Correct!' : 'Review the concept and try again.'
    };
  });

  const score = Math.round((correctCount / quiz.questions.length) * 100);

  return res.json({
    quizId,
    totalQuestions: quiz.questions.length,
    correct: correctCount,
    score, // 0..100
    feedback
  });
};
