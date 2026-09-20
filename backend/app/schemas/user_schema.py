from pydantic import BaseModel

class UserCreate(BaseModel):
    email: str

class UserResponse(BaseModel):
    id: int
    email: str
    is_premium: bool
    scans_used_today: int

    class Config:
        from_attributes = True