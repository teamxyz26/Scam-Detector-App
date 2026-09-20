from sqlalchemy import Column, Integer, String, Float, DateTime, Boolean, Date
from sqlalchemy.sql import func
from app.database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    is_premium = Column(Boolean, default=False)
    scans_used_today = Column(Integer, default=0)
    last_scan_date = Column(Date, nullable=True)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

class Scan(Base):
    __tablename__ = "scans"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, index=True)
    input_type = Column(String)
    input_value = Column(String)
    status = Column(String)
    confidence = Column(Float)
    reason = Column(String)
    created_at = Column(DateTime(timezone=True), server_default=func.now())