import os
import requests
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.schemas.url_schema import URLRequest, URLResponse
from app.database import get_db
from app import models
from app.utils import check_and_update_scan_limit

router = APIRouter()

SAFE_BROWSING_KEY = os.getenv("GOOGLE_SAFE_BROWSING_KEY")
SAFE_BROWSING_URL = f"https://safebrowsing.googleapis.com/v4/threatMatches:find?key={SAFE_BROWSING_KEY}"

FREE_SCAN_LIMIT = 3

@router.post("/check-url", response_model=URLResponse)
def check_url(request: URLRequest, db: Session = Depends(get_db)):
    user=db.query(models.User).filter(models.User.id==request.user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    allowed = check_and_update_scan_limit(user, db)
    if not allowed:
        raise HTTPException(status_code=403, detail="Free scan limit reached. Upgrade to premium for unlimited scans.")
    
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
        user_id=request.user_id,
        input_type="url",
        input_value=request.url,
        status=status,
        confidence=confidence,
        reason=reason
    )
    db.add(scan)

    

    db.commit()

    return URLResponse(status=status, confidence=confidence, reason=reason)