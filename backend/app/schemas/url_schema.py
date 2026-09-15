from pydantic import BaseModel

class URLRequest(BaseModel):
  url:str

class URLResponse(BaseModel):
  status: str
  confidence: float
  reason: str


