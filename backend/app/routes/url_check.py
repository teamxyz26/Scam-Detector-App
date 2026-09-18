import os
import requests
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.schemas.url_schema import URLRequest, URLResponse
from app.database import get_db
from app import models

router = APIRouter()

SAFE_BROWSING_KEY = os.getenv("GOOGLE_SAFE_BROWSING_KEY")
SAFE_BROWSING_URL = f"https://safebrowsing.googleapis.com/v4/threatMatches:find?key={SAFE_BROWSING_KEY}"

@router.post("/check-url", response_model=URLResponse)
def check_url(request: URLRequest, db: Session = Depends(get_db)):
    payload = {
        "client": {"clientId": "scamguard-ai", "clientVersion": "1.0"},
        "threatInfo": {
            "threatTypes": ["MALWARE", "SOCIAL_ENGINEERING", "UNWANTED_SOFTWARE", "POTENTIALLY_HARMFUL_APPLICATION"],
            "platformTypes": ["ANY_PLATFORM"],
            "threatEntryTypes": ["URL"],
            "threatEntries": [{"url": request.url}]
        }
    }

    response = requests.post(SAFE_BROWSING_URL, json=payload)
    result = response.json()

    if result:
        status, confidence, reason = "dangerous", 0.95, "This URL matches a known scam/malware/phishing database entry."
    else:
        status, confidence, reason = "safe", 0.8, "No known threats found for this URL."

    scan = models.Scan(
        user_id=None,
        input_type="url",
        input_value=request.url,
        status=status,
        confidence=confidence,
        reason=reason
    )
    db.add(scan)
    db.commit()

    return URLResponse(status=status, confidence=confidence, reason=reason)