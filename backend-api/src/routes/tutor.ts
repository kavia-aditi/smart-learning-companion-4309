import { Router } from 'express';
import { chatWithTutor } from '../controllers/tutorController';

const router = Router();

/**
 * POST /api/tutor/chat
 * Chat with AI tutor (stubbed heuristic response)
 */
router.post('/chat', chatWithTutor);

export default router;
