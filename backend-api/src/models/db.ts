import { v4 as uuidv4 } from 'uuid';
import type { Lesson, Quiz, Progress, Question } from './types';

function seedLessons(): Lesson[] {
  return [
    {
      id: 'lesson-1',
      title: 'Introduction to Variables',
      description: 'Learn what variables are and how to use them.',
      category: 'Programming Basics',
      durationMinutes: 5
    },
    {
      id: 'lesson-2',
      title: 'Control Flow Basics',
      description: 'Understand if-else and loops.',
      category: 'Programming Basics',
      durationMinutes: 7
    }
  ];
}

function seedQuizzes(): Quiz[] {
  const q1: Question = {
    id: 'q1',
    text: 'What is a variable?',
    options: [
      { id: 'o1', text: 'A storage location identified by a name' },
      { id: 'o2', text: 'A loop structure' },
      { id: 'o3', text: 'An error message' }
    ],
    correctOptionId: 'o1'
  };
  const q2: Question = {
    id: 'q2',
    text: 'Which is a valid variable name in many languages?',
    options: [
      { id: 'o1', text: '2value' },
      { id: 'o2', text: 'value_2' },
      { id: 'o3', text: 'value-2' }
    ],
    correctOptionId: 'o2'
  };
  const quiz1: Quiz = {
    id: 'quiz-1',
    lessonId: 'lesson-1',
    title: 'Variables Quiz',
    questions: [q1, q2]
  };

  const q3: Question = {
    id: 'q3',
    text: 'What does an if statement do?',
    options: [
      { id: 'o1', text: 'Repeats code indefinitely' },
      { id: 'o2', text: 'Executes code conditionally' },
      { id: 'o3', text: 'Stops the program' }
    ],
    correctOptionId: 'o2'
  };
  const quiz2: Quiz = {
    id: 'quiz-2',
    lessonId: 'lesson-2',
    title: 'Control Flow Quiz',
    questions: [q3]
  };

  return [quiz1, quiz2];
}

export const db: {
  lessons: Lesson[];
  quizzes: Quiz[];
  progress: Map<string, Progress>;
} = {
  lessons: seedLessons(),
  quizzes: seedQuizzes(),
  progress: new Map<string, Progress>()
};

// Utility to generate ids for future entity creations
export const genId = () => uuidv4();
