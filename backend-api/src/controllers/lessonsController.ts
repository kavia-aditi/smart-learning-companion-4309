import { Request, Response, NextFunction } from 'express';
import { db } from '../models/db';

// PUBLIC_INTERFACE
export const getLessons = (req: Request, res: Response, _next: NextFunction) => {
  /** List all lessons. */
  res.json({ lessons: db.lessons });
};

// PUBLIC_INTERFACE
export const getLessonById = (req: Request, res: Response, _next: NextFunction) => {
  /** Get lesson by id. */
  const { id } = req.params;
  const lesson = db.lessons.find((l) => l.id === id);
  if (!lesson) {
    return res.status(404).json({ error: 'Lesson not found' });
  }
  return res.json({ lesson });
};
