# Smart Learning Companion

An AI-powered micro learning tutor application that delivers bite-sized lessons and interactive quizzes, with an AI tutor powered by Ollama (default) or OpenAI.

This monorepo contains:
- micro_learning_ai_tutor_frontend (Flutter)
- backend-api (Node.js + TypeScript, main API used by the Flutter app)
- backend (Python FastAPI, separate AI/ML pipeline example; not required for the Flutter app)
- docker-compose.yml (brings up Ollama, backend-api, and the Flutter web frontend)

## Quick Start (Docker Compose)

Prerequisites:
- Docker and Docker Compose v2

Steps:
1) Prepare backend-api environment (optional; compose sets sensible defaults)
   cp smart-learning-companion-4309/backend-api/.env.example smart-learning-companion-4309/backend-api/.env
   # Optionally adjust values (CORS_ORIGIN, AI_PROVIDER, OLLAMA_* or OpenAI settings)

2) Start the stack (from repo root):
   docker compose up -d --build

Services:
- Frontend (Flutter web): http://localhost:3000
- Backend API (Node/Express): http://localhost:8080
- Ollama (model endpoint): http://localhost:11434

Notes about Ollama models:
- The first request to /api/tutor/chat with a new model (default: llama3:instruct) triggers a model pull that can take several minutes.
- You can pre-pull the model to speed up first response:
  docker exec -it ollama ollama pull llama3:instruct

Stopping:
- docker compose down

## Quick Start (Develop locally without Docker)

Backend API (Node + TS):
1) cd smart-learning-companion-4309/backend-api
2) npm install
3) cp .env.example .env
4) npm run dev
   - Server at http://localhost:8080
   - Health at http://localhost:8080/health

Flutter Frontend (mobile or web dev):
1) cd smart-learning-companion-4309/micro_learning_ai_tutor_frontend
2) flutter pub get
3) For emulator/device (mobile):
   flutter run --dart-define=BACKEND_BASE_URL=http://localhost:8080
4) For web dev:
   flutter run -d chrome --web-port 3000 --dart-define=BACKEND_BASE_URL=http://localhost:8080

## Endpoints (Backend API)

Base: http://localhost:8080

- GET /health
- GET /api/lessons
- GET /api/lessons/:id
- GET /api/quizzes?lessonId=...
- POST /api/quizzes/:quizId/submit
- GET /api/progress/:userId
- POST /api/progress/:userId
- POST /api/tutor/chat   (AI provider-based with Ollama default and rules-based fallback)

AI Provider configuration (via env/.env):
- AI_PROVIDER=ollama (default) | openai
- OLLAMA_BASE_URL=http://ollama:11434
- OLLAMA_MODEL=llama3:instruct
- (OpenAI) OPENAI_API_KEY, OPENAI_MODEL, OPENAI_BASE_URL

CORS:
- Controlled by CORS_ORIGIN in backend-api; defaults are permissive. Include http://localhost:3000 for web preview.

## Compose Networking Notes

- The Flutter web frontend container is built from micro_learning_ai_tutor_frontend/Dockerfile and served on port 3000 using a tiny static server.
- The frontend uses BACKEND_BASE_URL set to http://backend:8080 in docker-compose, which resolves to the backend-api service name on the compose network.
- The Flutter app also supports overriding the base URL via --dart-define=BACKEND_BASE_URL=... at build/run time.

## Repository Structure

smart-learning-companion-4309/
- micro_learning_ai_tutor_frontend/   (Flutter app; web build used in compose)
- backend-api/                        (Express + TypeScript backend used by the app)
- backend/                            (Python FastAPI example; not used by Flutter app)
- docker-compose.yml                  (Ollama + backend-api + Flutter web)
- README.md                           (this file)

## Troubleshooting

- Frontend shows network errors:
  - Ensure BACKEND_BASE_URL points to a reachable URL (http://localhost:8080 locally, or http://backend:8080 in compose).
  - Verify backend health: curl http://localhost:8080/health

- Tutor chat returns fallback messages:
  - Ollama model may still be downloading. Pre-pull with:
    docker exec -it ollama ollama pull llama3:instruct
  - Check backend logs for provider errors.

- CORS errors (in web dev):
  - Set backend-api CORS_ORIGIN to include your frontend origin(s), e.g. http://localhost:3000 or use * for permissive local dev.

- Build failures for Flutter Dockerfile:
  - The Dockerfile uses a public Flutter image; ensure network access during build.
  - You can also run Flutter locally without Docker as shown above.
