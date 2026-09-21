from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List
from app.schemas.scan_schema import ScanResponse
from app.database import get_db
from app import models

router = APIRouter()

@router.get("/users/{user_id}/scans", response_model=List[ScanResponse])
def get_scan_history(user_id: int, db: Session = Depends(get_db)):
    scans = (
        db.query(models.Scan)
        .filter(models.Scan.user_id == user_id)
        .order_by(models.Scan.created_at.desc())
        .all()
    )
    return scans