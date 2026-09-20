import os
import json
from google import genai
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.schemas.message_schema import MessageRequest, MessageResponse
from app.database import get_db
from app import models
from app.utils import check_and_update_scan_limit

router = APIRouter()

client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))

FREE_SCAN_LIMIT = 3

@router.post("/check-message", response_model=MessageResponse)
def check_message(request: MessageRequest, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.id == request.user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    allowed = check_and_update_scan_limit(user, db)
    if not allowed:
        raise HTTPException(status_code=403, detail="Free scan limit reached. Upgrade to premium for unlimited scans.")
    prompt = f"""
You are a scam detection assistant. Analyze this message and decide if it's a scam, phishing attempt, or safe.

Message: "{request.message}"

Respond ONLY with valid JSON in this exact format, nothing else:
{{
  "status": "safe" or "suspicious" or "dangerous",
  "confidence": a number between 0 and 1,
  "reason": "a short one-sentence explanation"
}}
"""

    response = client.models.generate_content(
        model="gemini-3.6-flash",
        contents=prompt
    )

    text = response.text.strip()
    text = text.replace("```json", "").replace("```", "").strip()
    data = json.loads(text)

    scan = models.Scan(
        user_id=request.user_id,
        input_type="message",
        input_value=request.message,
        status=data["status"],
        confidence=data["confidence"],
        reason=data["reason"]
    )
    db.add(scan)

    

    db.commit()

    return MessageResponse(
        status=data["status"],
        confidence=data["confidence"],
        reason=data["reason"]
    )