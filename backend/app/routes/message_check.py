import os
import json
from google import genai
from fastapi import APIRouter
from dotenv import load_dotenv
from app.schemas.message_schema import MessageRequest, MessageResponse

load_dotenv()

router = APIRouter()

client = genai.Client(api_key=os.getenv("GEMINI_API_KEY"))

@router.post("/check-message", response_model=MessageResponse)
def check_message(request: MessageRequest):
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

    return MessageResponse(
        status=data["status"],
        confidence=data["confidence"],
        reason=data["reason"]
    )