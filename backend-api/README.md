# Micro Learning Backend API (Node.js + TypeScript)

A lightweight Express + TypeScript backend for the Micro Learning AI Tutor app. Provides APIs for lessons, quizzes, user progress, and a tutor chat endpoint with provider-based AI (Ollama by default, OpenAI optional).

## Features

- Health check: `/health`
- Lessons: list and get
- Quizzes: list by lesson and submit answers (scoring + per-question feedback)
- Progress: get and upsert per user
- Tutor chat: AI provider-based with rules fallback
- TypeScript with zod validation and centralized error handling
- CORS enabled for Flutter web/preview

## Getting Started

1) Install dependencies
```
cd backend-api
npm install
```

2) Configure environment
```
cp .env.example .env
# adjust values if needed
```

3) Run in development (default http://localhost:8080)
```
npm run dev
```

4) Build and run (optional)
```
npm run build
npm start
```

The server listens on the PORT environment variable and defaults to 8080.

## AI Provider Configuration

The tutor chat at `/api/tutor/chat` supports switching between providers via environment variables.

```
# Provider selection: 'ollama' (default) or 'openai'
AI_PROVIDER=ollama

# Ollama settings (local via docker-compose)
OLLAMA_BASE_URL=http://ollama:11434
OLLAMA_MODEL=llama3:instruct

# OpenAI settings (only if AI_PROVIDER=openai)
OPENAI_API_KEY=sk-...
OPENAI_MODEL=gpt-4o-mini-2024-07-18
OPENAI_BASE_URL=https://api.openai.com
```

Behavior:
- If the selected provider fails or is unreachable, the endpoint falls back to a rules-based response.
- History is bounded to the last 10 exchanges (20 turns).

### Running with Docker Compose (Ollama)

At the repository root, `docker-compose.yml` includes an `ollama` service and configures the backend to use it.

Steps:
1. From the repo root, run: `docker compose up -d`
2. On first chat request, Ollama may need to pull the model (`llama3:instruct`). This can take several minutes.

Optional pre-pull to speed up first response:
```
docker exec -it <ollama_container_name> ollama pull llama3:instruct
```

### Test the Chat Endpoint

Example cURL:
```
curl -X POST http://localhost:8080/api/tutor/chat \
  -H "Content-Type: application/json" \
  -d '{"message":"Explain photosynthesis briefly","context":{"history":[]}}'
```

Response format:
```
{
  "reply": " ... assistant message ... ",
  "model": "llama3:instruct",
  "provider": "ollama"
}
```

### Notes on Models

- Default model: `llama3:instruct`. You can change `OLLAMA_MODEL` to other locally available models supported by Ollama.
- First use of a new model triggers a model download. Ensure adequate disk space and allow time for the pull.

## API Endpoints

Base URL: `http://localhost:8080`

- GET `/health` -> `{ "status": "ok" }`
- GET `/api/lessons`
- GET `/api/lessons/:id`
- GET `/api/quizzes?lessonId=lesson-1`
- POST `/api/quizzes/:quizId/submit`
- GET `/api/progress/:userId`
- POST `/api/progress/:userId`
- POST `/api/tutor/chat` (AI provider-based with rules fallback)

## Environment Variables (summary)

- PORT=8080
- NODE_ENV=development
- CORS_ORIGIN=http://localhost:3000
  - For docker-compose with the Flutter web frontend served on port 3000, include http://localhost:3000.
  - For permissive local development you may set CORS_ORIGIN=* (not recommended for production).
- AI_PROVIDER=ollama
- OLLAMA_BASE_URL=http://ollama:11434
- OLLAMA_MODEL=llama3:instruct
- (Optional) OPENAI_API_KEY, OPENAI_MODEL, OPENAI_BASE_URL

## Docker

Build the image:
```
docker build -t micro-learning-backend-api:latest .
```

Run the container (exposes 8080):
```
docker run --rm -p 8080:8080 \
  -e PORT=8080 \
  --name micro-learning-backend-api \
  micro-learning-backend-api:latest
```

Environment file:
```
# create once
cp .env.example .env
# then pass it to docker
docker run --rm -p 8080:8080 --env-file .env micro-learning-backend-api:latest
```
