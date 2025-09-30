from fastapi import APIRouter, Depends, HTTPException
from ..utils.security import get_current_user
from ..db.inmemory import db
from ..models.schemas import ModelDesignCreate, ModelDesign
from ..utils.responses import success

router = APIRouter()

def to_model(m: dict) -> ModelDesign:
    return ModelDesign(
        id=m["id"],
        project_id=m["project_id"],
        algorithm=m["algorithm"],
        objective=m["objective"],
        hyperparams_json=m["hyperparams_json"],
        notes=m.get("notes"),
        created_at=m["created_at"],
        updated_at=m["updated_at"],
    )

# PUBLIC_INTERFACE
@router.post("/projects/{project_id}/models", summary="Create model design", response_model=dict)
def create_model(project_id: str, payload: ModelDesignCreate, user_id: str = Depends(get_current_user)):
    p = db.projects.get(project_id)
    if not p or p["owner_user_id"] != user_id:
        raise HTTPException(status_code=404, detail="Project not found")
    mid = db._uuid()
    m = {
        "id": mid,
        "project_id": project_id,
        "algorithm": payload.algorithm,
        "objective": payload.objective,
        "hyperparams_json": payload.hyperparams,
        "created_at": db._now(),
        "updated_at": db._now(),
    }
    db.model_designs[mid] = m
    return success(to_model(m).model_dump())

# PUBLIC_INTERFACE
@router.get("/projects/{project_id}/models", summary="List model designs", response_model=dict)
def list_models(project_id: str, user_id: str = Depends(get_current_user)):
    p = db.projects.get(project_id)
    if not p or p["owner_user_id"] != user_id:
        raise HTTPException(status_code=404, detail="Project not found")
    items = [to_model(m).model_dump() for m in db.model_designs.values() if m["project_id"] == project_id]
    return success(items)
