from fastapi import FastAPI, Depends, Request
from fastapi.middleware.cors import CORSMiddleware
from pydantic_settings import BaseSettings
from typing import List
from .routes import auth, projects, datasets, preprocess, models, training, candidates, evaluation, inference, visualization, stream
from .utils.responses import api_meta

class Settings(BaseSettings):
    APP_NAME: str = "Micro Learning AI Tutor API"
    APP_VERSION: str = "0.1.0"
    APP_DESCRIPTION: str = "API for micro-learning AI tutor supporting lessons, quizzes, user progress, and adaptive learning."
    API_PREFIX: str = "/api/v1"
    JWT_SECRET: str = "dev-secret"
    JWT_ALG: str = "HS256"
    JWT_EXPIRE_MINUTES: int = 120
    CORS_ORIGINS: str = "*"

    class Config:
        env_file = ".env"
        case_sensitive = True

settings = Settings()

openapi_tags = [
    {"name": "Auth", "description": "Authentication routes (JWT Bearer)."},
    {"name": "Projects", "description": "Create and manage projects."},
    {"name": "Datasets", "description": "Upload and manage datasets."},
    {"name": "Preprocessing", "description": "Configure and run preprocessing jobs."},
    {"name": "Models", "description": "Model design and training orchestration."},
    {"name": "Training", "description": "Training run status and fit evaluation."},
    {"name": "Candidates", "description": "Model candidate promotion and listing."},
    {"name": "Evaluation", "description": "Final evaluation on test split."},
    {"name": "Inference", "description": "Online prediction endpoints."},
    {"name": "Visualization", "description": "Retrieve visualization artifacts."},
    {"name": "Stream", "description": "Server-Sent Events for job status updates."},
]

app = FastAPI(
    title=settings.APP_NAME,
    description=settings.APP_DESCRIPTION + "\n\nWebSocket/SSE note: This API exposes SSE endpoints under /stream.* Use EventSource in clients to receive real-time job status updates.",
    version=settings.APP_VERSION,
    openapi_tags=openapi_tags,
)

# CORS
origins: List[str] = [o.strip() for o in settings.CORS_ORIGINS.split(",") if o.strip()]
app.add_middleware(
    CORSMiddleware,
    allow_origins=origins if origins != ["*"] else ["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
prefix = settings.API_PREFIX
app.include_router(auth.router, prefix=prefix, tags=["Auth"])
app.include_router(projects.router, prefix=prefix, tags=["Projects"])
app.include_router(datasets.router, prefix=prefix, tags=["Datasets"])
app.include_router(preprocess.router, prefix=prefix, tags=["Preprocessing"])
app.include_router(models.router, prefix=prefix, tags=["Models"])
app.include_router(training.router, prefix=prefix, tags=["Training"])
app.include_router(candidates.router, prefix=prefix, tags=["Candidates"])
app.include_router(evaluation.router, prefix=prefix, tags=["Evaluation"])
app.include_router(inference.router, prefix=prefix, tags=["Inference"])
app.include_router(visualization.router, prefix=prefix, tags=["Visualization"])
app.include_router(stream.router, prefix=prefix, tags=["Stream"])

# PUBLIC_INTERFACE
@app.get("/api/v1/websocket-docs", tags=["Stream"], summary="WebSocket/SSE usage help")
def websocket_docs():
    """Provide usage notes for SSE endpoints used for real-time job status.
    Returns:
        Standard envelope with links and sample JS usage for EventSource.
    """
    return {
        "success": True,
        "data": {
            "sse_endpoints": [
                "/api/v1/stream",
                "/api/v1/preprocess/stream/{run_id}",
            ],
            "sample_js": "const es = new EventSource('/api/v1/stream'); es.onmessage = (e) => console.log(e.data);",
        },
        "meta": api_meta(),
    }
