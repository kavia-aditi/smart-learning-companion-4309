from fastapi import APIRouter, Depends, HTTPException
from typing import Dict, Any
from ..utils.security import get_current_user
from ..db.inmemory import db
from ..models.schemas import PreprocessConfigCreate, PreprocessConfig, PreprocessRunCreate, PreprocessRun
from ..utils.responses import success

router = APIRouter()

def to_config(c: dict) -> PreprocessConfig:
    return PreprocessConfig(
        id=c["id"],
        project_id=c["project_id"],
        dataset_id=c["dataset_id"],
        target_column=c.get("target_column"),
        feature_columns=c.get("feature_columns", []),
        steps_json=c.get("steps_json", {}),
        random_seed=c.get("random_seed"),
        created_at=c["created_at"],
        updated_at=c["updated_at"],
    )

def to_run(r: dict) -> PreprocessRun:
    return PreprocessRun(
        id=r["id"],
        preprocess_config_id=r["preprocess_config_id"],
        status=r["status"],
        logs_uri=r.get("logs_uri"),
        output_train_uri=r.get("output_train_uri"),
        output_val_uri=r.get("output_val_uri"),
        output_test_uri=r.get("output_test_uri"),
        feature_store_uri=r.get("feature_store_uri"),
        metrics_json=r.get("metrics_json", {}),
        started_at=r.get("started_at"),
        completed_at=r.get("completed_at"),
    )

# PUBLIC_INTERFACE
@router.post("/projects/{project_id}/preprocess/config", summary="Create preprocess config", response_model=dict)
def create_preprocess_config(project_id: str, payload: PreprocessConfigCreate, user_id: str = Depends(get_current_user)):
    p = db.projects.get(project_id)
    if not p or p["owner_user_id"] != user_id:
        raise HTTPException(status_code=404, detail="Project not found")
    if payload.dataset_id not in db.datasets:
        raise HTTPException(status_code=404, detail="Dataset not found")
    cid = db._uuid()
    c = {
        "id": cid,
        "project_id": project_id,
        "dataset_id": payload.dataset_id,
        "target_column": payload.target_column,
        "feature_columns": payload.feature_columns,
        "steps_json": payload.steps_json,
        "random_seed": payload.seed,
        "created_at": db._now(),
        "updated_at": db._now(),
    }
    db.preprocess_configs[cid] = c
    return success(to_config(c).model_dump())

# PUBLIC_INTERFACE
@router.get("/preprocess/configs/{config_id}", summary="Get preprocess config", response_model=dict)
def get_preprocess_config(config_id: str, user_id: str = Depends(get_current_user)):
    c = db.preprocess_configs.get(config_id)
    if not c:
        raise HTTPException(status_code=404, detail="Not found")
    proj = db.projects.get(c["project_id"])
    if not proj or proj["owner_user_id"] != user_id:
        raise HTTPException(status_code=403, detail="Forbidden")
    return success(to_config(c).model_dump())

# PUBLIC_INTERFACE
@router.post("/preprocess/configs/{config_id}/runs", summary="Create preprocess run", response_model=dict)
def create_preprocess_run(config_id: str, _: PreprocessRunCreate, user_id: str = Depends(get_current_user)):
    c = db.preprocess_configs.get(config_id)
    if not c:
        raise HTTPException(status_code=404, detail="Config not found")
    proj = db.projects.get(c["project_id"])
    if not proj or proj["owner_user_id"] != user_id:
        raise HTTPException(status_code=403, detail="Forbidden")
    rid = db._uuid()
    r: Dict[str, Any] = {
        "id": rid,
        "preprocess_config_id": config_id,
        "status": "completed",
        "logs_uri": f"preprocess/{rid}/logs.txt",
        "output_train_uri": f"preprocess/{rid}/train.parquet",
        "output_val_uri": f"preprocess/{rid}/val.parquet",
        "output_test_uri": f"preprocess/{rid}/test.parquet",
        "metrics_json": {"missing_ratio": 0.01},
        "started_at": db._now(),
        "completed_at": db._now(),
    }
    db.preprocess_runs[rid] = r
    return success(to_run(r).model_dump())

# PUBLIC_INTERFACE
@router.get("/preprocess/runs/{run_id}", summary="Get preprocess run status", response_model=dict)
def get_preprocess_run(run_id: str, user_id: str = Depends(get_current_user)):
    r = db.preprocess_runs.get(run_id)
    if not r:
        raise HTTPException(status_code=404, detail="Not found")
    c = db.preprocess_configs.get(r["preprocess_config_id"])
    proj = db.projects.get(c["project_id"]) if c else None
    if not proj or proj["owner_user_id"] != user_id:
        raise HTTPException(status_code=403, detail="Forbidden")
    return success(to_run(r).model_dump())
