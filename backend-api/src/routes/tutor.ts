import { Router } from 'express';
import { chatWithTutor } from '../controllers/tutorController';

const router = Router();

/**
 * POST /api/tutor/chat
 * Chat with AI tutor (OpenAI-backed, with safe fallbacks)
 */
router.post('/chat', chatWithTutor);

export default router;
