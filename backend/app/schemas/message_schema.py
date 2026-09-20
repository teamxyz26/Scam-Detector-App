from pydantic import BaseModel

class MessageRequest(BaseModel):
  message:str
  user_id: int

class MessageResponse(BaseModel):
  status: str
  confidence: float
  reason: str

  