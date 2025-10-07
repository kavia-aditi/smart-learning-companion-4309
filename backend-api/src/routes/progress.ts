import { Router } from 'express';
import { getProgress, upsertProgress } from '../controllers/progressController';

const router = Router();

/**
 * GET /api/progress/:userId
 * Fetch progress by userId
 */
router.get('/:userId', getProgress);

/**
 * POST /api/progress/:userId
 * Upsert progress payload
 */
router.post('/:userId', upsertProgress);

export default router;
