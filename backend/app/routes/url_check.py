import os
import requests
from fastapi import APIRouter
from dotenv import load_dotenv
from app.schemas.url_schema import URLRequest, URLResponse

load_dotenv()

router = APIRouter()

SAFE_BROWSING_KEY = os.getenv("GOOGLE_SAFE_BROWSING_KEY")
SAFE_BROWSING_URL = f"https://safebrowsing.googleapis.com/v4/threatMatches:find?key={SAFE_BROWSING_KEY}"

@router.post("/check-url", response_model=URLResponse)
def check_url(request: URLRequest):
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
        return URLResponse(
            status="dangerous",
            confidence=0.95,
            reason="This URL matches a known scam/malware/phishing database entry."
        )
    else:
        return URLResponse(
            status="safe",
            confidence=0.8,
            reason="No known threats found for this URL."
        )