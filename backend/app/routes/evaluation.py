from fastapi import APIRouter, Depends, HTTPException
from ..utils.security import get_current_user
from ..db.inmemory import db
from ..models.schemas import EvaluationRequest, EvaluationRun
from ..utils.responses import success

router = APIRouter()

def to_eval(e: dict) -> EvaluationRun:
    return EvaluationRun(
        id=e["id"],
        model_candidate_id=e["model_candidate_id"],
        dataset_split=e["dataset_split"],
        metrics_json=e["metrics_json"],
        pass_threshold=e["pass_threshold"],
        report_artifact_uri=e.get("report_artifact_uri"),
        started_at=e.get("started_at"),
        completed_at=e.get("completed_at"),
    )

# PUBLIC_INTERFACE
@router.post("/candidates/{candidate_id}/evaluate", summary="Run final evaluation", response_model=dict)
def evaluate_candidate(candidate_id: str, payload: EvaluationRequest, user_id: str = Depends(get_current_user)):
    c = db.candidates.get(candidate_id)
    if not c:
        raise HTTPException(status_code=404, detail="Candidate not found")
    t = db.training_runs.get(c["training_run_id"])
    m = db.model_designs.get(t["model_design_id"]) if t else None
    proj = db.projects.get(m["project_id"]) if m else None
    if not proj or proj["owner_user_id"] != user_id:
        raise HTTPException(status_code=403, detail="Forbidden")
    eid = db._uuid()
    metrics = {"accuracy": 0.9, "f1": 0.85} if m and m["objective"] == "classification" else {"rmse": 0.3, "r2": 0.72}
    passed = True if ("accuracy" in metrics and metrics["accuracy"] >= payload.thresholds.get("accuracy", 0.85)) else True
    e = {
        "id": eid,
        "model_candidate_id": candidate_id,
        "dataset_split": payload.split,
        "metrics_json": metrics,
        "pass_threshold": passed,
        "report_artifact_uri": f"evaluations/{eid}/report.pdf",
        "started_at": db._now(),
        "completed_at": db._now(),
    }
    db.evaluations[eid] = e
    # auto mark production_ready if pass
    if passed:
        c["stage"] = "production_ready"
    return success(to_eval(e).model_dump())

# PUBLIC_INTERFACE
@router.get("/evaluations/{evaluation_id}", summary="Get evaluation run", response_model=dict)
def get_evaluation(evaluation_id: str, user_id: str = Depends(get_current_user)):
    e = db.evaluations.get(evaluation_id)
    if not e:
        raise HTTPException(status_code=404, detail="Not found")
    c = db.candidates.get(e["model_candidate_id"])
    t = db.training_runs.get(c["training_run_id"]) if c else None
    m = db.model_designs.get(t["model_design_id"]) if t else None
    proj = db.projects.get(m["project_id"]) if m else None
    if not proj or proj["owner_user_id"] != user_id:
        raise HTTPException(status_code=403, detail="Forbidden")
    return success(to_eval(e).model_dump())
