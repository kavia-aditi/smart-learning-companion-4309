# Micro-Learning AI Tutor Backend

A FastAPI backend implementing the AI/ML pipeline endpoints for the Micro-Learning AI Tutor app.

Tech:
- Python 3.11+
- FastAPI + Pydantic
- JWT bearer auth
- In-memory store (for demo); replace with PostgreSQL/S3/Redis as needed

Run:
1) Create venv and install:
   pip install -r requirements.txt
2) Set env (see .env.example)
3) Start:
   uvicorn app.main:app --host 0.0.0.0 --port 8080 --reload

Base URL:
- http://localhost:8080/api/v1

Notes:
- This is a reference implementation with stubbed async jobs and artifacts.
- SSE endpoints are implemented with simple generators for demo purposes.
- Replace InMemoryDB with real persistence for production.
