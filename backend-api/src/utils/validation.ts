import { z } from 'zod';

export const AnswerSchema = z.object({
  questionId: z.string().min(1),
  answer: z.string().min(1)
});

export const SubmitQuizSchema = z.object({
  answers: z.array(AnswerSchema).min(1)
});

export const ProgressUpsertSchema = z.object({
  completedLessons: z.array(z.string().min(1)).default([]),
  lastActiveAt: z.string().datetime().optional()
});

const ChatRoleEnum = z.enum(['user', 'assistant', 'system']);

export const ChatMessageSchema = z.object({
  role: ChatRoleEnum,
  content: z.string().min(1)
});

export const TutorChatSchema = z.object({
  message: z.string().min(1, 'message is required'),
  userId: z.string().min(1).optional(),
  context: z
    .object({
      lessonId: z.string().min(1).optional(),
      quizId: z.string().min(1).optional(),
      history: z
        .array(
          z.object({
            role: ChatRoleEnum,
            content: z.string().min(1),
          })
        )
        .optional()
    })
    .optional()
});
