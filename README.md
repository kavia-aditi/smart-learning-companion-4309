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

## Running with Docker Compose

This repository includes a top-level docker-compose.yml to run the backend API and the Flutter frontend together.

Prerequisites:
- Docker (https://docs.docker.com/get-docker/)
- Docker Compose (v2 is included with modern Docker Desktop/Engine)

Steps:
1) Configure backend environment:
   - If using the Node.js backend (backend-api), copy its example env to a real one:
     cp smart-learning-companion-4309/backend-api/.env.example smart-learning-companion-4309/backend-api/.env
   - Open smart-learning-companion-4309/backend-api/.env and set required values:
     - OPENAI_API_KEY=your_key_here
     - Optional: model and other tuning variables as needed
   - Note: The compose file provides a default PORT=8080 if not set.

2) Build and start services:
   - From the repository root (where docker-compose.yml lives), run:
     docker compose up --build

3) Access the apps:
   - Frontend: http://localhost:3000
   - Backend health: http://localhost:8080/health

Networking details:
- The frontend talks to the backend via the Docker network using API_BASE_URL=http://backend:8080 (configured in compose).
- Services are attached to the smart-learning-net bridge network and discover each other by service name.

Notes for the Flutter frontend:
- The docker-compose.yml assumes there is a Dockerfile in:
  smart-learning-companion-4309/micro_learning_ai_tutor_frontend/Dockerfile
- If this file does not exist yet, add one (for Flutter web or dev serving) or update compose to use a community Flutter image.
- Keep the exposed port at 3000 for consistency with the preview and compose mapping.

Stopping:
- Press Ctrl+C in the compose terminal, or run:
  docker compose down
