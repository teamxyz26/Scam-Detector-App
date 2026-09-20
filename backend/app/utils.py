from datetime import date
from sqlalchemy.orm import Session
from app import models

def check_and_update_scan_limit(user: models.User, db: Session, free_limit: int = 3):
    today = date.today()

    # If it's a new day since their last scan, reset their count
    if user.last_scan_date != today:
        user.scans_used_today = 0
        user.last_scan_date = today

    if not user.is_premium and user.scans_used_today >= free_limit:
        return False  # blocked

    if not user.is_premium:
        user.scans_used_today += 1

    return True  # allowed