# micro_learning_ai_tutor_frontend

Mobile frontend for Micro-Learning AI Tutor.

Ocean Professional theme, bottom navigation (Home, Learn, Quizzes, Profile), mock lessons/quizzes, and in-memory progress.

## Quick Start

1) Install dependencies
   flutter pub get

2) Run on device/emulator
   flutter run

Notes:
- The app is self-contained and uses bundled mock data (assets/mock/*.json). No backend required.
- For existing preview setup, no script changes are needed; main.dart runs by default.

## Tabs

- Home: Greeting, progress summary, and a horizontally scrollable "Suggested lessons" carousel.
- Learn: List of lessons from mock data; tap opens detail screen with sections and a "Start micro-lesson" CTA that advances progress in-memory.
- Quizzes: List of quizzes; tap to attempt a quiz in a single-question flow with basic feedback and in-memory score tracking.
- Profile: Simple stats and settings placeholders.

## Architecture

- Theme: lib/theme/app_theme.dart (Ocean Professional colors, typography, components)
- State: Provider + ChangeNotifier (lib/core/state/app_state.dart) with in-memory lesson progress and quiz scores
- Models: lib/core/models/lesson.dart, lib/core/models/quiz.dart
- Services: Stubbed services with mock data and future API shapes
  - lib/core/services/lesson_service.dart
  - lib/core/services/quiz_service.dart
  - lib/core/services/tutor_service.dart (AI placeholder)
- Repos: Simple wrappers for services for easy swapping to real APIs later
  - lib/core/repositories/lesson_repository.dart
  - lib/core/repositories/quiz_repository.dart
- Features:
  - Home: lib/features/home/*
  - Learn: lib/features/learn/*
  - Quizzes: lib/features/quizzes/*
  - Profile: lib/features/profile/*
- Widgets:
  - Shimmer skeletons: lib/widgets/shimmer_box.dart

## UI polish & animations

- Theme refinements: consistent spacing (8/12/16/24), rounded corners (12–16), subtle elevations, gradient headers.
- Animations:
  - Tab transitions use AnimatedSwitcher for smooth cross-fades and slight slides.
  - Lists/cards animate on appearance (fade+translate) and have press feedback (tiny scale change).
  - Hero transition between lesson title in list/card and Lesson Detail app bar.
  - Quiz attempt area switches with AnimatedSwitcher.
  - Shimmer placeholders during loading states (Home/Learn/Quizzes).
- Accessibility:
  - Minimum tap sizes for buttons and controls.
  - Reduced motion support via kReduceMotion flag.

Toggle reduced motion:
- Open lib/app.dart and set:
  const bool kReduceMotion = true;

This disables most animations and is useful for CI or users who prefer reduced motion.

## Backend Integration (optional)

This app also contains utilities for optional integration:

- Legacy FastAPI backend (in this monorepo)
  - Base URL via --dart-define FASTAPI_BASE_URL (fallback API_BASE_URL)
  - Default: http://localhost:8080/api/v1
  - Client: lib/services/api_client.dart
  - Example:
    flutter run --dart-define=FASTAPI_BASE_URL=http://localhost:8080/api/v1

- Node.js backend (future)
  - Base URL via --dart-define NODE_API_BASE_URL
  - Default: http://localhost:3000
  - Service: lib/services/api_service.dart
  - Example:
    flutter run --dart-define=NODE_API_BASE_URL=http://localhost:3000

## Environment variables

- Not required for current mock-only experience.
- See .env.example for future variables.

## Tests

- Unit tests for ApiService mock integration and basic widget rendering exist.
  flutter test --concurrency=1
