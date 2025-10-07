import { Router } from 'express';
import { getLessons, getLessonById } from '../controllers/lessonsController';

const router = Router();

/**
 * GET /api/lessons
 * List all lessons
 */
router.get('/', getLessons);

/**
 * GET /api/lessons/:id
 * Get a specific lesson by id
 */
router.get('/:id', getLessonById);

export default router;
