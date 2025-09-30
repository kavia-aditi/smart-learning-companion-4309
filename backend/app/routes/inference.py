from fastapi import APIRouter, Depends, HTTPException
from typing import Dict, Any
from ..utils.security import get_current_user
from ..db.inmemory import db
from ..models.schemas import PredictRequest, BatchPredictRequest, InferenceResponse
from ..utils.responses import success

router = APIRouter()

def to_inference(i: dict) -> InferenceResponse:
    return InferenceResponse(
        id=i["id"],
        model_candidate_id=i.get("model_candidate_id"),
        input_payload_json=i["input_payload_json"],
        output_payload_json=i["output_payload_json"],
        latency_ms=i["latency_ms"],
        created_at=i["created_at"],
    )

# PUBLIC_INTERFACE
@router.post("/projects/{project_id}/predict", summary="Predict online", response_model=dict)
def predict(project_id: str, payload: PredictRequest, user_id: str = Depends(get_current_user)):
    p = db.projects.get(project_id)
    if not p or p["owner_user_id"] != user_id:
        raise HTTPException(status_code=404, detail="Project not found")
    # choose candidate: use provided or first production_ready
    candidate_id = payload.candidate_id
    if not candidate_id:
        for c in db.candidates.values():
            t = db.training_runs.get(c["training_run_id"])
            m = db.model_designs.get(t["model_design_id"]) if t else None
            if m and m["project_id"] == project_id and c["stage"] == "production_ready":
                candidate_id = c["id"]
                break
    iid = db._uuid()
    # simulate prediction by echoing inputs with a "prediction" field
    outputs = [{"prediction": 1, **x} for x in payload.inputs]
    i = {
        "id": iid,
        "model_candidate_id": candidate_id,
        "input_payload_json": {"inputs": payload.inputs},
        "output_payload_json": {"outputs": outputs},
        "latency_ms": 25,
        "created_at": db._now(),
    }
    db.inferences[iid] = i
    return success(to_inference(i).model_dump())

# PUBLIC_INTERFACE
@router.post("/predict/batch", summary="Batch predict", response_model=dict)
def predict_batch(payload: BatchPredictRequest, user_id: str = Depends(get_current_user)):
    d = db.datasets.get(payload.dataset_id)
    if not d:
        raise HTTPException(status_code=404, detail="Dataset not found")
    proj = db.projects.get(d["project_id"])
    if not proj or proj["owner_user_id"] != user_id:
        raise HTTPException(status_code=403, detail="Forbidden")
    iid = db._uuid()
    i = {
        "id": iid,
        "model_candidate_id": payload.candidate_id,
        "input_payload_json": {"dataset_id": payload.dataset_id},
        "output_payload_json": {"outputs_uri": f"inference/{iid}/outputs.parquet"},
        "latency_ms": 2000,
        "created_at": db._now(),
    }
    db.inferences[iid] = i
    return success(to_inference(i).model_dump())

# PUBLIC_INTERFACE
@router.get("/inferences/{inference_id}", summary="Get inference result", response_model=dict)
def get_inference(inference_id: str, user_id: str = Depends(get_current_user)):
    i = db.inferences.get(inference_id)
    if not i:
        raise HTTPException(status_code=404, detail="Not found")
    # check project ownership through candidate -> training -> model -> project if available
    cid = i.get("model_candidate_id")
    if cid:
        c = db.candidates.get(cid)
        t = db.training_runs.get(c["training_run_id"]) if c else None
        m = db.model_designs.get(t["model_design_id"]) if t else None
        proj = db.projects.get(m["project_id"]) if m else None
        if not proj or proj["owner_user_id"] != user_id:
            raise HTTPException(status_code=403, detail="Forbidden")
    return success(to_inference(i).model_dump())
