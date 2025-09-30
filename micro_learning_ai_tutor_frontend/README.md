# micro_learning_ai_tutor_frontend

Mobile frontend for Micro-Learning AI Tutor.

## Backend Integration

This app supports two API backends:

1) Legacy FastAPI (existing in this monorepo)
- Base URL via dart-define FASTAPI_BASE_URL (fallback to API_BASE_URL)
- Defaults: http://localhost:8080/api/v1
- Client: lib/services/api_client.dart

2) New Node.js backend (this task)
- Base URL via dart-define NODE_API_BASE_URL
- Defaults: http://localhost:3000
- Service: lib/services/api_service.dart

Run examples:

- Node backend (registration and lessons list):
  flutter run --dart-define=NODE_API_BASE_URL=http://localhost:3000

- FastAPI backend (projects list demo on home screen):
  flutter run --dart-define=FASTAPI_BASE_URL=http://localhost:8080/api/v1

## Example Usage

Register user (Node):
```dart
final api = ApiService();
await api.registerUser(email: 'user@example.com', name: 'User', password: 'secret123');
```

Fetch lessons (Node):
```dart
final lessons = await ApiService().fetchLessons();
```

Login and list projects (FastAPI example already wired in HomeDashboardScreen):
```dart
final client = ApiClient();
final logged = await client.login(email: 'demo@example.com', password: 'demo1234');
if (logged) {
  final projects = await client.listProjects();
}
```

## Running tests

- Ensure Flutter SDK is available.
- From micro_learning_ai_tutor_frontend directory:
  flutter test --concurrency=1

Notes:
- Tests use http/testing MockClient to simulate the Node backend for:
  - POST /api/v1/register
  - GET /api/v1/lessons
- No external services are started and tests run in CI-friendly, non-interactive mode.

## Notes
- Do not hardcode URLs. Prefer --dart-define at build time.
- SharedPreferences key 'auth_token' is reused for bearer auth if the Node backend also issues JWT on login later.
