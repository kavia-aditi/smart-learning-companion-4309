import uuid
import time
from typing import Dict, Any, List, Optional

class InMemoryDB:
    def __init__(self) -> None:
        self.users: Dict[str, Dict[str, Any]] = {}
        self.projects: Dict[str, Dict[str, Any]] = {}
        self.datasets: Dict[str, Dict[str, Any]] = {}
        self.preprocess_configs: Dict[str, Dict[str, Any]] = {}
        self.preprocess_runs: Dict[str, Dict[str, Any]] = {}
        self.model_designs: Dict[str, Dict[str, Any]] = {}
        self.training_runs: Dict[str, Dict[str, Any]] = {}
        self.candidates: Dict[str, Dict[str, Any]] = {}
        self.evaluations: Dict[str, Dict[str, Any]] = {}
        self.inferences: Dict[str, Dict[str, Any]] = {}
        self.visualizations: Dict[str, Dict[str, Any]] = {}

    def _now(self) -> str:
        return time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())

    def _uuid(self) -> str:
        return str(uuid.uuid4())

db = InMemoryDB()
