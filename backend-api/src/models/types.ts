export interface Lesson {
  id: string;
  title: string;
  description: string;
  category?: string;
  durationMinutes?: number;
}

export interface QuestionOption {
  id: string;
  text: string;
}

export interface Question {
  id: string;
  text: string;
  options: QuestionOption[];
  correctOptionId: string;
}

export interface Quiz {
  id: string;
  lessonId: string;
  title: string;
  questions: Question[];
}

export interface Progress {
  userId: string;
  completedLessons: string[];
  lastActiveAt: string; // ISO date string
}

export type ChatRole = 'user' | 'assistant' | 'system';

export interface ChatMessage {
  role: ChatRole;
  content: string;
}
