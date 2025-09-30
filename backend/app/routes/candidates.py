from fastapi import APIRouter, Depends, HTTPException
from ..utils.security import get_current_user
from ..db.inmemory import db
from ..models.schemas import CandidateCreate, Candidate, CandidateUpdate
from ..utils.responses import success

router = APIRouter()

def to_candidate(c: dict) -> Candidate:
    return Candidate(
        id=c["id"],
        training_run_id=c["training_run_id"],
        stage=c["stage"],
        notes=c.get("notes"),
        created_at=c["created_at"],
        updated_at=c["updated_at"],
    )

# PUBLIC_INTERFACE
@router.post("/training/runs/{training_run_id}/candidates", summary="Create model candidate", response_model=dict)
def create_candidate(training_run_id: str, payload: CandidateCreate, user_id: str = Depends(get_current_user)):
    t = db.training_runs.get(training_run_id)
    if not t:
        raise HTTPException(status_code=404, detail="Training run not found")
    m = db.model_designs.get(t["model_design_id"])
    proj = db.projects.get(m["project_id"]) if m else None
    if not proj or proj["owner_user_id"] != user_id:
        raise HTTPException(status_code=403, detail="Forbidden")
    cid = db._uuid()
    c = {
        "id": cid,
        "training_run_id": training_run_id,
        "stage": "draft",
        "notes": payload.notes,
        "created_at": db._now(),
        "updated_at": db._now(),
    }
    db.candidates[cid] = c
    return success(to_candidate(c).model_dump())

# PUBLIC_INTERFACE
@router.get("/projects/{project_id}/candidates", summary="List candidates for project", response_model=dict)
def list_candidates(project_id: str, user_id: str = Depends(get_current_user)):
    p = db.projects.get(project_id)
    if not p or p["owner_user_id"] != user_id:
        raise HTTPException(status_code=404, detail="Project not found")
    items = []
    for c in db.candidates.values():
        t = db.training_runs.get(c["training_run_id"])
        m = db.model_designs.get(t["model_design_id"]) if t else None
        if m and m["project_id"] == project_id:
            items.append(to_candidate(c).model_dump())
    return success(items)

# PUBLIC_INTERFACE
@router.patch("/candidates/{candidate_id}", summary="Update candidate stage", response_model=dict)
def update_candidate(candidate_id: str, payload: CandidateUpdate, user_id: str = Depends(get_current_user)):
    c = db.candidates.get(candidate_id)
    if not c:
        raise HTTPException(status_code=404, detail="Not found")
    t = db.training_runs.get(c["training_run_id"])
    m = db.model_designs.get(t["model_design_id"]) if t else None
    proj = db.projects.get(m["project_id"]) if m else None
    if not proj or proj["owner_user_id"] != user_id:
        raise HTTPException(status_code=403, detail="Forbidden")
    c["stage"] = payload.stage
    c["updated_at"] = db._now()
    return success(to_candidate(c).model_dump())
