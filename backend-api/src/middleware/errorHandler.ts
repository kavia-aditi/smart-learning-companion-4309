import { NextFunction, Request, Response } from 'express';

// PUBLIC_INTERFACE
export function notFoundHandler(req: Request, res: Response, _next: NextFunction) {
  /** Express 404 handler. */
  res.status(404).json({ error: 'Not Found', path: req.originalUrl });
}

// PUBLIC_INTERFACE
export function errorHandler(err: any, _req: Request, res: Response, _next: NextFunction) {
  /** Centralized error handler. */
  const status = err?.status || 500;
  const message = err?.message || 'Internal Server Error';
  // eslint-disable-next-line no-console
  console.error('Error:', err);
  res.status(status).json({ error: message });
}
