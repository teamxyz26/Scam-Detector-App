from pydantic import BaseModel

class MessageRequest(BaseModel):
  message:str

class MessageResponse(BaseModel):
  status: str
  confidence: float
  reason: str

  