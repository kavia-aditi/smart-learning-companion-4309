# Micro Learning Backend API (Node.js + TypeScript)

A lightweight Express + TypeScript backend for the Micro Learning AI Tutor app. Provides APIs for lessons, quizzes, user progress, and a stubbed AI tutor chat endpoint. Designed for easy expansion (e.g., swap in SQLite later).

## Features

- Health check: `/health`
- Lessons: list and get
- Quizzes: list by lesson and submit answers (scoring + per-question feedback)
- Progress: get and upsert per user
- Tutor chat: simple rule-based responses (placeholder for future OpenAI integration)
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

3) Run in development (default http://localhost:4000)
```
npm run dev
```

4) Build and run (optional)
```
npm run build
npm start
```

### Environment Variables

- PORT=4000
- OPENAI_API_KEY= (optional; reserved for future integration)
- NODE_ENV=development
- CORS_ORIGIN=http://localhost:3000

Create `.env` based on `.env.example`.

## API Endpoints

Base URL: `http://localhost:4000`

### Health
- GET `/health` -> `{ "status": "ok" }`

### Lessons
- GET `/api/lessons`
  - Response: `{ lessons: Lesson[] }`
- GET `/api/lessons/:id`
  - Response: `{ lesson: Lesson }`
  - 404 if not found

### Quizzes
- GET `/api/quizzes?lessonId=lesson-1`
  - Response: `{ quizzes: Quiz[] }`
  - 400 if `lessonId` missing
- POST `/api/quizzes/:quizId/submit`
  - Body:
    ```
    {
      "answers": [
        { "questionId": "q1", "answer": "o1" }
      ]
    }
    ```
  - Response:
    ```
    {
      "quizId": "quiz-1",
      "totalQuestions": 2,
      "correct": 1,
      "score": 50,
      "feedback": [
        {
          "questionId": "q1",
          "correct": true,
          "correctOptionId": "o1",
          "explanation": "Correct!"
        }
      ]
    }
    ```
  - 404 if quiz not found
  - 400 if payload invalid

### Progress
- GET `/api/progress/:userId`
  - Response:
    ```
    {
      "userId": "user-123",
      "progress": {
        "userId": "user-123",
        "completedLessons": [],
        "lastActiveAt": "2025-01-01T00:00:00.000Z"
      }
    }
    ```
- POST `/api/progress/:userId`
  - Body:
    ```
    {
      "completedLessons": ["lesson-1"],
      "lastActiveAt": "2025-01-01T00:00:00.000Z"
    }
    ```
  - Response mirrors GET with merged/upserted data

### Tutor (AI Chat - Stub)
- POST `/api/tutor/chat`
  - Body:
    ```
    {
      "userId": "user-123",
      "messages": [
        {"role": "user", "content": "Can you explain?"}
      ],
      "context": { "lessonId": "lesson-1" }
    }
    ```
  - Response:
    ```
    {
      "userId": "user-123",
      "messages": [..., {"role":"assistant","content":"..."}],
      "reply": {"role":"assistant","content":"..."}
    }
    ```
  - Heuristics:
    - If a lessonId is provided, mention lesson title in response.
    - If user asks to "explain" → provide explanation.
    - If user asks for an "example" → provide example.
    - If "quiz" is mentioned → suggest a related quiz.

Note: TODO to integrate OpenAI with `OPENAI_API_KEY` in the future.

## Data Models (TypeScript)

- Lesson: `{ id, title, description, category?, durationMinutes? }`
- Quiz: `{ id, lessonId, title, questions: Question[] }`
- Question: `{ id, text, options: {id,text}[], correctOptionId }`
- Progress: `{ userId, completedLessons: string[], lastActiveAt: ISOString }`
- ChatMessage: `{ role: 'user'|'assistant'|'system', content: string }`

## CORS

CORS is configured to allow:
- `CORS_ORIGIN` from `.env` (default includes http://localhost:3000)
- Fallback allows any origin for development convenience (tighten for production).

## Flutter Integration

- Base URL for development: `http://localhost:4000`
- Endpoints under `/api/...`
- Health check at `/health` for connectivity testing

## Future Work

- Replace in-memory store with SQLite/Prisma or another lightweight DB.
- AuthN/AuthZ for user routes.
- OpenAI (or similar) integration in Tutor endpoint.

## License

MIT
