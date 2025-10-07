# micro_learning_ai_tutor_frontend

Mobile frontend for the Micro Learning AI Tutor.

Ocean Professional theme, bottom navigation (Home, Learn, Quizzes, Profile), mock lessons/quizzes, and in-memory progress.

## Quick Start

1) Install dependencies  
   flutter pub get

2) Run on device/emulator (mock data only)  
   flutter run

Notes:
- The app works out-of-the-box with bundled mock data in assets/mock/*.json.
- Backend connectivity is optional. See Networking and Environment Configuration below.

## Tabs

- Home: Greeting, progress summary, and a horizontally scrollable "Suggested lessons" carousel.
- Learn: List of lessons; tap opens detail screen with sections and a "Start micro-lesson" CTA that advances progress in-memory.
- Quizzes: List of quizzes; tap to attempt a quiz in a single-question flow with basic feedback and in-memory score tracking.
- Profile: Simple stats and settings placeholders.

## Architecture

- Theme: lib/theme/app_theme.dart (Ocean Professional colors, typography, components)
- State: Provider + ChangeNotifier (lib/core/state/app_state.dart) with in-memory lesson progress and quiz scores
- Models: lib/core/models/lesson.dart, lib/core/models/quiz.dart
- Services (mock + API-ready):
  - lib/core/services/lesson_service.dart
  - lib/core/services/quiz_service.dart
  - lib/core/services/tutor_service.dart (AI placeholder)
- Repos:
  - lib/core/repositories/lesson_repository.dart
  - lib/core/repositories/quiz_repository.dart
- Features:
  - Home: lib/features/home/*
  - Learn: lib/features/learn/*
  - Quizzes: lib/features/quizzes/*
  - Profile: lib/features/profile/*
- Widgets:
  - Shimmer skeletons: lib/widgets/shimmer_box.dart

## Networking and Environment Configuration

A lightweight networking layer is provided for calling the backend through docker-compose networking or a local URL.

- Base URL default (compose network): http://backend-api:8080
- Override at build/run time via --dart-define:
  flutter run --dart-define=BACKEND_BASE_URL=http://localhost:8080

Environment is read by lib/config/env.dart:
```dart
class AppEnv {
  static const String backendBaseUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: 'http://backend-api:8080',
  );
}
```

Shared API client:
- lib/services/api_client.dart (GET/POST with JSON headers and error handling)

Service endpoints:
- LessonsService: GET /api/lessons
- QuizzesService: GET /api/quizzes
- ProgressService: POST /api/progress
- TutorService: POST /api/tutor/chat

These services target the base URL from AppEnv.backendBaseUrl and do not hardcode localhost.

## Example Usage (Development)

A minimal wiring example is provided at:
- lib/example/wiring_example.dart

You can temporarily call it from main() to verify connectivity:
```dart
// import 'package:micro_learning_ai_tutor_frontend/example/wiring_example.dart';
// await runWiringExample();
```

Service snippets:
```dart
final lessons = await LessonsService().listLessons();
final quizzes = await QuizzesService().listQuizzes();
final progressRes = await ProgressService().upsertProgress(
  userId: 'user-123',
  lessonId: 'lesson-1',
  score: 95,
);
final chatRes = await TutorService().chat(
  message: 'Hello tutor!',
  history: const [{'role':'system','content':'You are a helpful micro-learning tutor.'}],
);
```

## Example curl

- Lessons:
  curl -X GET "$BACKEND_BASE_URL/api/lessons" -H "accept: application/json"

- Quizzes:
  curl -X GET "$BACKEND_BASE_URL/api/quizzes" -H "accept: application/json"

- Progress:
  curl -X POST "$BACKEND_BASE_URL/api/progress" \
    -H "Content-Type: application/json" \
    -d '{"userId":"user-123","lessonId":"lesson-1","score":88}'

- Tutor Chat:
  curl -X POST "$BACKEND_BASE_URL/api/tutor/chat" \
    -H "Content-Type: application/json" \
    -d '{"message":"Hi tutor! Any tips?","history":[{"role":"system","content":"You are helpful."}]}'

## Running with docker-compose

When using the monorepo docker-compose, the app will target http://backend-api:8080 by default via compose networking. No extra flags required.

## Running locally without compose

If your backend is on localhost:8080:
- flutter run --dart-define=BACKEND_BASE_URL=http://localhost:8080

## Dependencies

This project uses the http package for networking.
Declared in pubspec.yaml:
```yaml
dependencies:
  http: ^1.2.2
```

## Tests

- Widget and basic integration tests:
  flutter test --concurrency=1

## Notes

- Avoid hardcoding localhost; always use AppEnv.backendBaseUrl.
- The wiring example is not part of production UI and should be used only for manual verification.
