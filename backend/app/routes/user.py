from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.schemas.user_schema import UserCreate, UserResponse
from app.database import get_db
from app import models

router = APIRouter()

@router.post("/users", response_model=UserResponse)
def create_user(request: UserCreate, db: Session = Depends(get_db)):
    existing = db.query(models.User).filter(models.User.email == request.email).first()
    if existing:
        return existing

    new_user = models.User(email=request.email)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)
    return new_user

@router.get("/users/{user_id}", response_model=UserResponse)
def get_user(user_id: int, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user