from typing import List, Optional, Dict, Any, Literal
from pydantic import BaseModel, Field, EmailStr

# Auth
class RegisterRequest(BaseModel):
    email: EmailStr = Field(..., description="User email")
    name: str = Field(..., description="Full name")
    password: str = Field(..., description="Password (plain for demo)")

class LoginRequest(BaseModel):
    email: EmailStr = Field(..., description="User email")
    password: str = Field(..., description="Password (plain for demo)")

class MeResponse(BaseModel):
    id: str
    email: EmailStr
    name: str
    role: str

class TokenResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"

# Projects
class ProjectCreate(BaseModel):
    name: str = Field(..., description="Project name")
    description: Optional[str] = None

class ProjectUpdate(BaseModel):
    name: Optional[str] = None
    description: Optional[str] = None
    status: Optional[Literal["active", "archived"]] = None

class Project(BaseModel):
    id: str
    owner_user_id: str
    name: str
    description: Optional[str] = None
    status: str
    created_at: str
    updated_at: str

# Datasets
class DatasetCreate(BaseModel):
    name: str
    description: Optional[str] = None
    file_type: Literal["csv", "parquet", "json"] = "csv"

class Dataset(BaseModel):
    id: str
    project_id: str
    name: str
    description: Optional[str] = None
    storage_uri: str
    file_type: str
    row_count: int
    column_count: int
    schema_json: Dict[str, Any]
    created_at: str
    updated_at: str

# Preprocess
class PreprocessConfigCreate(BaseModel):
    dataset_id: str
    target_column: Optional[str] = None
    feature_columns: List[str] = []
    steps_json: Dict[str, Any] = Field(default_factory=dict)
    split: Dict[str, float] = Field(default_factory=lambda: {"train": 0.7, "val": 0.15, "test": 0.15})
    seed: Optional[int] = 42

class PreprocessConfig(BaseModel):
    id: str
    project_id: str
    dataset_id: str
    target_column: Optional[str] = None
    feature_columns: List[str]
    steps_json: Dict[str, Any]
    random_seed: Optional[int] = 42
    created_at: str
    updated_at: str

class PreprocessRunCreate(BaseModel):
    pass

class PreprocessRun(BaseModel):
    id: str
    preprocess_config_id: str
    status: Literal["queued", "running", "completed", "failed"]
    logs_uri: Optional[str] = None
    output_train_uri: Optional[str] = None
    output_val_uri: Optional[str] = None
    output_test_uri: Optional[str] = None
    feature_store_uri: Optional[str] = None
    metrics_json: Dict[str, Any] = Field(default_factory=dict)
    started_at: Optional[str] = None
    completed_at: Optional[str] = None

# Models & Training
class ModelDesignCreate(BaseModel):
    algorithm: str
    objective: Literal["classification", "regression"]
    hyperparams: Dict[str, Any] = Field(default_factory=dict)

class ModelDesign(BaseModel):
    id: str
    project_id: str
    algorithm: str
    objective: str
    hyperparams_json: Dict[str, Any]
    notes: Optional[str] = None
    created_at: str
    updated_at: str

class TrainRequest(BaseModel):
    preprocess_run_id: str

class TrainingRun(BaseModel):
    id: str
    model_design_id: str
    preprocess_run_id: str
    status: Literal["queued", "running", "completed", "failed"]
    train_metrics_json: Dict[str, Any] = Field(default_factory=dict)
    val_metrics_json: Dict[str, Any] = Field(default_factory=dict)
    model_artifact_uri: Optional[str] = None
    feature_columns: List[str] = []
    target_column: Optional[str] = None
    started_at: Optional[str] = None
    completed_at: Optional[str] = None

class FitEvaluateRequest(BaseModel):
    thresholds: Dict[str, Any] = Field(default_factory=dict)

class FitEvaluateResponse(BaseModel):
    passed: bool
    recommendations: List[str] = []

# Candidates
class CandidateCreate(BaseModel):
    notes: Optional[str] = None

class Candidate(BaseModel):
    id: str
    training_run_id: str
    stage: Literal["draft", "staging", "production_rejected", "production_ready"]
    notes: Optional[str] = None
    created_at: str
    updated_at: str

class CandidateUpdate(BaseModel):
    stage: Literal["draft", "staging", "production_rejected", "production_ready"]

# Evaluation
class EvaluationRequest(BaseModel):
    split: Literal["test", "custom"] = "test"
    thresholds: Dict[str, Any] = Field(default_factory=dict)

class EvaluationRun(BaseModel):
    id: str
    model_candidate_id: str
    dataset_split: str
    metrics_json: Dict[str, Any]
    pass_threshold: bool
    report_artifact_uri: Optional[str] = None
    started_at: Optional[str] = None
    completed_at: Optional[str] = None

# Inference
class PredictRequest(BaseModel):
    inputs: List[Dict[str, Any]]
    candidate_id: Optional[str] = None

class BatchPredictRequest(BaseModel):
    dataset_id: str
    candidate_id: Optional[str] = None

class InferenceResponse(BaseModel):
    id: str
    model_candidate_id: Optional[str]
    input_payload_json: Dict[str, Any]
    output_payload_json: Dict[str, Any]
    latency_ms: int
    created_at: str

# Visualization
class Visualization(BaseModel):
    id: str
    project_id: str
    type: str
    storage_uri: str
    created_at: str
