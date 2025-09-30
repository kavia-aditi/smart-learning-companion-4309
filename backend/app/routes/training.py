from fastapi import APIRouter, Depends, HTTPException
from ..utils.security import get_current_user
from ..db.inmemory import db
from ..models.schemas import TrainRequest, TrainingRun, FitEvaluateRequest, FitEvaluateResponse
from ..utils.responses import success

router = APIRouter()

def to_training(t: dict) -> TrainingRun:
    return TrainingRun(
        id=t["id"],
        model_design_id=t["model_design_id"],
        preprocess_run_id=t["preprocess_run_id"],
        status=t["status"],
        train_metrics_json=t.get("train_metrics_json", {}),
        val_metrics_json=t.get("val_metrics_json", {}),
        model_artifact_uri=t.get("model_artifact_uri"),
        feature_columns=t.get("feature_columns", []),
        target_column=t.get("target_column"),
        started_at=t.get("started_at"),
        completed_at=t.get("completed_at"),
    )

# PUBLIC_INTERFACE
@router.post("/models/{model_design_id}/train", summary="Start training run", response_model=dict)
def start_training(model_design_id: str, payload: TrainRequest, user_id: str = Depends(get_current_user)):
    m = db.model_designs.get(model_design_id)
    if not m:
        raise HTTPException(status_code=404, detail="Model design not found")
    proj = db.projects.get(m["project_id"])
    if not proj or proj["owner_user_id"] != user_id:
        raise HTTPException(status_code=403, detail="Forbidden")
    pr = db.preprocess_runs.get(payload.preprocess_run_id)
    if not pr:
        raise HTTPException(status_code=404, detail="Preprocess run not found")
    tid = db._uuid()
    t = {
        "id": tid,
        "model_design_id": model_design_id,
        "preprocess_run_id": payload.preprocess_run_id,
        "status": "completed",
        "train_metrics_json": {"loss": [1.0, 0.5, 0.2]},
        "val_metrics_json": {"accuracy": 0.88, "f1": 0.83},
        "model_artifact_uri": f"models/{tid}/model.bin",
        "started_at": db._now(),
        "completed_at": db._now(),
    }
    db.training_runs[tid] = t
    return success(to_training(t).model_dump())

# PUBLIC_INTERFACE
@router.get("/training/runs/{training_run_id}", summary="Get training run", response_model=dict)
def get_training(training_run_id: str, user_id: str = Depends(get_current_user)):
    t = db.training_runs.get(training_run_id)
    if not t:
        raise HTTPException(status_code=404, detail="Not found")
    m = db.model_designs.get(t["model_design_id"])
    proj = db.projects.get(m["project_id"]) if m else None
    if not proj or proj["owner_user_id"] != user_id:
        raise HTTPException(status_code=403, detail="Forbidden")
    return success(to_training(t).model_dump())

# PUBLIC_INTERFACE
@router.post("/training/runs/{training_run_id}/evaluate-fit", summary="Evaluate fit (gate)", response_model=dict)
def evaluate_fit(training_run_id: str, payload: FitEvaluateRequest, user_id: str = Depends(get_current_user)):
    t = db.training_runs.get(training_run_id)
    if not t:
        raise HTTPException(status_code=404, detail="Not found")
    m = db.model_designs.get(t["model_design_id"])
    proj = db.projects.get(m["project_id"]) if m else None
    if not proj or proj["owner_user_id"] != user_id:
        raise HTTPException(status_code=403, detail="Forbidden")

    metrics = t.get("val_metrics_json", {})
    # Defaults per guide
    acc_thresh = payload.thresholds.get("accuracy", 0.85)
    f1_thresh = payload.thresholds.get("f1", 0.80)
    passed = metrics.get("accuracy", 0) >= acc_thresh and metrics.get("f1", 0) >= f1_thresh
    recommendations = [] if passed else ["Increase estimators", "Try regularization", "Collect more data"]
    resp = FitEvaluateResponse(passed=passed, recommendations=recommendations)
    return success(resp.model_dump())
