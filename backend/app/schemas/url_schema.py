from pydantic import BaseModel

class URLRequest(BaseModel):
  url:str
  user_id: int

class URLResponse(BaseModel):
  status: str
  confidence: float
  reason: str


