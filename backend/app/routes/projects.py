from fastapi import APIRouter, Depends, HTTPException, status, Query
from typing import List
from ..utils.security import get_current_user
from ..db.inmemory import db
from ..models.schemas import ProjectCreate, ProjectUpdate, Project
from ..utils.responses import success

router = APIRouter()

def to_project(p: dict) -> Project:
    return Project(
        id=p["id"],
        owner_user_id=p["owner_user_id"],
        name=p["name"],
        description=p.get("description"),
        status=p["status"],
        created_at=p["created_at"],
        updated_at=p["updated_at"],
    )

# PUBLIC_INTERFACE
@router.get("/projects", summary="List projects", response_model=dict)
def list_projects(page: int = Query(1, ge=1), page_size: int = Query(20, ge=1, le=100), user_id: str = Depends(get_current_user)):
    """List projects for current user with simple pagination."""
    items = [to_project(p).model_dump() for p in db.projects.values() if p["owner_user_id"] == user_id]
    total = len(items)
    start = (page - 1) * page_size
    end = start + page_size
    return {"success": True, "data": items[start:end], "meta": {"page": page, "page_size": page_size, "total": total}}

# PUBLIC_INTERFACE
@router.post("/projects", summary="Create project", response_model=dict)
def create_project(payload: ProjectCreate, user_id: str = Depends(get_current_user)):
    """Create a new project."""
    pid = db._uuid()
    p = {
        "id": pid,
        "owner_user_id": user_id,
        "name": payload.name,
        "description": payload.description,
        "status": "active",
        "created_at": db._now(),
        "updated_at": db._now(),
    }
    db.projects[pid] = p
    return success(to_project(p).model_dump())

# PUBLIC_INTERFACE
@router.get("/projects/{project_id}", summary="Get project", response_model=dict)
def get_project(project_id: str, user_id: str = Depends(get_current_user)):
    p = db.projects.get(project_id)
    if not p or p["owner_user_id"] != user_id:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Not found")
    return success(to_project(p).model_dump())

# PUBLIC_INTERFACE
@router.patch("/projects/{project_id}", summary="Update project", response_model=dict)
def update_project(project_id: str, payload: ProjectUpdate, user_id: str = Depends(get_current_user)):
    p = db.projects.get(project_id)
    if not p or p["owner_user_id"] != user_id:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Not found")
    if payload.name is not None:
        p["name"] = payload.name
    if payload.description is not None:
        p["description"] = payload.description
    if payload.status is not None:
        p["status"] = payload.status
    p["updated_at"] = db._now()
    return success(to_project(p).model_dump())

# PUBLIC_INTERFACE
@router.delete("/projects/{project_id}", summary="Delete project", response_model=dict)
def delete_project(project_id: str, user_id: str = Depends(get_current_user)):
    p = db.projects.get(project_id)
    if not p or p["owner_user_id"] != user_id:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Not found")
    del db.projects[project_id]
    return success({"deleted": True})
