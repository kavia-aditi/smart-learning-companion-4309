import { Request, Response, NextFunction } from 'express';
import { db } from '../models/db';
import { ProgressUpsertSchema } from '../utils/validation';

// PUBLIC_INTERFACE
export const getProgress = (req: Request, res: Response, _next: NextFunction) => {
  /** Fetch progress by userId. */
  const { userId } = req.params;
  const progress = db.progress.get(userId);
  return res.json({
    userId,
    progress: progress ?? { userId, completedLessons: [], lastActiveAt: new Date().toISOString() }
  });
};

// PUBLIC_INTERFACE
export const upsertProgress = (req: Request, res: Response, _next: NextFunction) => {
  /** Upsert progress payload. */
  const { userId } = req.params;
  const parsed = ProgressUpsertSchema.safeParse(req.body);
  if (!parsed.success) {
    return res.status(400).json({ error: 'Invalid payload', details: parsed.error.flatten() });
  }
  const { completedLessons, lastActiveAt } = parsed.data;

  const existing = db.progress.get(userId);
  const merged = {
    userId,
    completedLessons: Array.from(new Set([...(existing?.completedLessons ?? []), ...completedLessons])),
    lastActiveAt: lastActiveAt || new Date().toISOString()
  };
  db.progress.set(userId, merged);
  return res.json({ userId, progress: merged });
};
