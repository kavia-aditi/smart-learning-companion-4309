import { Router } from 'express';
import { getQuizzesByLesson, submitQuiz } from '../controllers/quizzesController';

const router = Router();

/**
 * GET /api/quizzes?lessonId=...
 * List quizzes for a given lessonId
 */
router.get('/', getQuizzesByLesson);

/**
 * POST /api/quizzes/:quizId/submit
 * Submit answers to a quiz and receive score and feedback
 */
router.post('/:quizId/submit', submitQuiz);

export default router;
