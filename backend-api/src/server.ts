import express, { Application } from 'express';
import cors from 'cors';
import dotenv from 'dotenv';

import lessonsRouter from './routes/lessons';
import quizzesRouter from './routes/quizzes';
import progressRouter from './routes/progress';
import tutorRouter from './routes/tutor';
import { errorHandler, notFoundHandler } from './middleware/errorHandler';

dotenv.config();

const app: Application = express();

// Basic CORS configuration: allow configured origin, fallback to * for now.
const allowedOrigins = (process.env.CORS_ORIGIN || '*')
  .split(',')
  .map((o) => o.trim());

app.use(
  cors({
    origin: (origin, callback) => {
      if (!origin || allowedOrigins.includes('*') || allowedOrigins.includes(origin)) {
        callback(null, true);
      } else {
        callback(null, true); // Temporarily allow all; tighten later
      }
    },
    credentials: true
  })
);

// Middleware
app.use(express.json({ limit: '1mb' }));

// Health check
app.get('/health', (_req, res) => {
  res.json({ status: 'ok' });
});

// API routes
app.use('/api/lessons', lessonsRouter);
app.use('/api/quizzes', quizzesRouter);
app.use('/api/progress', progressRouter);
app.use('/api/tutor', tutorRouter);

// Not found and error handlers
app.use(notFoundHandler);
app.use(errorHandler);

const PORT = Number(process.env.PORT) || 4000;
app.listen(PORT, () => {
  // eslint-disable-next-line no-console
  console.log(`Backend API listening on http://localhost:${PORT}`);
});

export default app;
