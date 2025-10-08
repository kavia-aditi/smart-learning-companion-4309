# Riverpod Prototype Mode

This app includes a Riverpod-based prototype using local mock repositories.

- Models: lib/models
- Mock repos: lib/repositories/mock
- Providers: lib/providers
- Screens (prototype): 
  - Lessons list: lib/ui/screens/home_screen.dart
  - Lesson detail: lib/ui/screens/lesson_detail_screen.dart
  - Quiz: lib/ui/screens/quiz_screen.dart
  - Dashboard: lib/ui/screens/dashboard_screen.dart

Entry points:
- Production shell (existing): lib/main.dart -> AiTutorApp (routes /login -> /home)
- Prototype shell (alternative): lib/app.dart -> RiverpodAppShell

To quickly test prototype without login, you can set RiverpodAppShell as your app in main if desired.
