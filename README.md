# Project Repository

This repository contains:
- micro_learning_ai_tutor_frontend (Flutter)
- backend (FastAPI) implementing the AI/ML pipeline endpoints

Quick start:
1) Backend
   cd smart-learning-companion-4309/backend
   pip install -r requirements.txt
   cp .env.example .env
   ./run.sh
   API at http://localhost:8080/api/v1

2) Frontend (Flutter)
   cd smart-learning-companion-4309/micro_learning_ai_tutor_frontend
   flutter pub get
   flutter run

Preview/Manifest:
- This repo includes a manifest at .kavia/manifest.json registering the Flutter container:
  name: micro_learning_ai_tutor_frontend
  type: flutter
  platform: mobile
  container_root: smart-learning-companion-4309/micro_learning_ai_tutor_frontend
  preview_port: 3000
- Preview systems can use this to auto-start the Flutter web-server on port 3000.

Integration:
- Frontend uses a minimal ApiClient to authenticate a demo user and list projects.
- Update API_BASE_URL at build time using --dart-define=API_BASE_URL=http://localhost:8080/api/v1