import os
from fastapi import APIRouter, Request, Header, HTTPException, Depends
from sqlalchemy.orm import Session
from app.database import get_db
from app import models

router = APIRouter()

REVENUECAT_SECRET = os.getenv("REVENUECAT_WEBHOOK_SECRET")

@router.post("/webhook/revenuecat")
async def revenuecat_webhook(
    request: Request,
    authorization: str = Header(None),
    db: Session = Depends(get_db)
):
    if authorization != REVENUECAT_SECRET:
        raise HTTPException(status_code=401, detail="Invalid webhook signature")

    payload = await request.json()
    event = payload.get("event", {})
    event_type = event.get("type")
    app_user_id = event.get("app_user_id")

    print(f"Received RevenueCat event: {event_type} for user {app_user_id}")

    user = db.query(models.User).filter(models.User.email == app_user_id).first()

    if user:
        if event_type in ["INITIAL_PURCHASE", "RENEWAL", "UNCANCELLATION"]:
            user.is_premium = True
            db.commit()
        elif event_type in ["CANCELLATION", "EXPIRATION"]:
            user.is_premium = False
            db.commit()

    return {"status": "received"}