from pydantic import BaseModel
from datetime import datetime

class ScanResponse(BaseModel):
    id: int
    input_type: str
    input_value: str
    status: str
    confidence: float
    reason: str
    created_at: datetime

    class Config:
        from_attributes = True