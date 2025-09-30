from fastapi import APIRouter, Depends, HTTPException
from ..utils.security import get_current_user
from ..db.inmemory import db
from ..models.schemas import DatasetCreate, Dataset
from ..utils.responses import success

router = APIRouter()

def to_dataset(d: dict) -> Dataset:
    return Dataset(
        id=d["id"],
        project_id=d["project_id"],
        name=d["name"],
        description=d.get("description"),
        storage_uri=d["storage_uri"],
        file_type=d["file_type"],
        row_count=d["row_count"],
        column_count=d["column_count"],
        schema_json=d["schema_json"],
        created_at=d["created_at"],
        updated_at=d["updated_at"],
    )

# PUBLIC_INTERFACE
@router.post("/projects/{project_id}/datasets", summary="Create dataset (stubbed upload)", response_model=dict)
def create_dataset(project_id: str, payload: DatasetCreate, user_id: str = Depends(get_current_user)):
    p = db.projects.get(project_id)
    if not p or p["owner_user_id"] != user_id:
        raise HTTPException(status_code=404, detail="Project not found")
    did = db._uuid()
    d = {
        "id": did,
        "project_id": project_id,
        "name": payload.name,
        "description": payload.description,
        "storage_uri": f"datasets/{did}/raw.{payload.file_type}",
        "file_type": payload.file_type,
        "row_count": 1000,
        "column_count": 10,
        "schema_json": {"columns": [{"name": f"col_{i}", "type": "float"} for i in range(10)]},
        "created_at": db._now(),
        "updated_at": db._now(),
    }
    db.datasets[did] = d
    return success(to_dataset(d).model_dump())

# PUBLIC_INTERFACE
@router.get("/projects/{project_id}/datasets", summary="List datasets for project", response_model=dict)
def list_datasets(project_id: str, user_id: str = Depends(get_current_user)):
    p = db.projects.get(project_id)
    if not p or p["owner_user_id"] != user_id:
        raise HTTPException(status_code=404, detail="Project not found")
    items = [to_dataset(d).model_dump() for d in db.datasets.values() if d["project_id"] == project_id]
    return success(items)

# PUBLIC_INTERFACE
@router.get("/datasets/{dataset_id}", summary="Get dataset", response_model=dict)
def get_dataset(dataset_id: str, user_id: str = Depends(get_current_user)):
    d = db.datasets.get(dataset_id)
    if not d:
        raise HTTPException(status_code=404, detail="Not found")
    proj = db.projects.get(d["project_id"])
    if not proj or proj["owner_user_id"] != user_id:
        raise HTTPException(status_code=403, detail="Forbidden")
    return success(to_dataset(d).model_dump())

# PUBLIC_INTERFACE
@router.delete("/datasets/{dataset_id}", summary="Delete dataset", response_model=dict)
def delete_dataset(dataset_id: str, user_id: str = Depends(get_current_user)):
    d = db.datasets.get(dataset_id)
    if not d:
        raise HTTPException(status_code=404, detail="Not found")
    proj = db.projects.get(d["project_id"])
    if not proj or proj["owner_user_id"] != user_id:
        raise HTTPException(status_code=403, detail="Forbidden")
    del db.datasets[dataset_id]
    return success({"deleted": True})
