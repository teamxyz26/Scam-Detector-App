from fastapi import APIRouter
from app.schemas.url_schema import URLRequest, URLResponse

router=APIRouter()

@router.post("/check-url",response_model= URLResponse)
def check_url(request: URLRequest):
  return URLResponse(
    status="safe",
    confidence=0.95,
    reason="This is placeholder data — real detection coming soon"
  )