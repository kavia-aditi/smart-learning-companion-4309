from fastapi import APIRouter
from fastapi.responses import StreamingResponse
import asyncio
import json
from typing import AsyncGenerator

router = APIRouter()

async def _event_stream(prefix: str) -> AsyncGenerator[str, None]:
    for i in range(1, 6):
        await asyncio.sleep(1)
        yield f"data: {json.dumps({'message': f'{prefix} event {i}', 'progress': i*20})}\n\n"

# PUBLIC_INTERFACE
@router.get("/stream", summary="Global SSE stream", response_description="text/event-stream")
async def stream():
    """SSE endpoint broadcasting demo global events for job status."""
    return StreamingResponse(_event_stream("global"), media_type="text/event-stream")

# PUBLIC_INTERFACE
@router.get("/preprocess/stream/{run_id}", summary="Preprocess run SSE stream", response_description="text/event-stream")
async def preprocess_stream(run_id: str):
    """SSE endpoint for a specific preprocess run."""
    return StreamingResponse(_event_stream(f"preprocess:{run_id}"), media_type="text/event-stream")
