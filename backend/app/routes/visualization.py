from fastapi import APIRouter, Depends, HTTPException
from ..utils.security import get_current_user
from ..db.inmemory import db
from ..models.schemas import Visualization
from ..utils.responses import success

router = APIRouter()

def to_viz(v: dict) -> Visualization:
    return Visualization(
        id=v["id"], project_id=v["project_id"], type=v["type"], storage_uri=v["storage_uri"], created_at=v["created_at"]
    )

# PUBLIC_INTERFACE
@router.get("/projects/{project_id}/visualizations", summary="List visualization artifacts", response_model=dict)
def list_visualizations(project_id: str, user_id: str = Depends(get_current_user)):
    p = db.projects.get(project_id)
    if not p or p["owner_user_id"] != user_id:
        raise HTTPException(status_code=404, detail="Project not found")
    items = [to_viz(v).model_dump() for v in db.visualizations.values() if v["project_id"] == project_id]
    return success(items)

# PUBLIC_INTERFACE
@router.get("/visualizations/{viz_id}", summary="Get visualization artifact", response_model=dict)
def get_visualization(viz_id: str, user_id: str = Depends(get_current_user)):
    v = db.visualizations.get(viz_id)
    if not v:
        raise HTTPException(status_code=404, detail="Not found")
    proj = db.projects.get(v["project_id"])
    if not proj or proj["owner_user_id"] != user_id:
        raise HTTPException(status_code=403, detail="Forbidden")
    return success(to_viz(v).model_dump())
