import time
import uuid
from typing import Any, Dict, Optional

def api_meta() -> Dict[str, Any]:
    return {
        "request_id": str(uuid.uuid4()),
        "duration_ms": int(1000 * (time.perf_counter() % 1.0)),  # demo value
    }

def success(data: Any, meta: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
    return {"success": True, "data": data, "meta": meta or api_meta()}

def error(code: str, message: str, status: int = 400, details: Optional[Dict[str, Any]] = None) -> Dict[str, Any]:
    return {
        "success": False,
        "error": {"code": code, "message": message, "details": details or {}},
        "meta": api_meta(),
    }
