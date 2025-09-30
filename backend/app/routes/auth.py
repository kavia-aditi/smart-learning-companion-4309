from fastapi import APIRouter, HTTPException, status, Depends
from passlib.hash import bcrypt
from ..utils.security import create_access_token, get_current_user
from ..db.inmemory import db
from ..models.schemas import RegisterRequest, LoginRequest, TokenResponse, MeResponse
from ..utils.responses import success

router = APIRouter()

# PUBLIC_INTERFACE
@router.post("/auth/register", summary="Register a new user", response_model=dict)
def register(payload: RegisterRequest):
    """Register a user.
    Body: email, name, password
    Returns: standard envelope with minimal user info.
    """
    for u in db.users.values():
        if u["email"] == payload.email:
            raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail="User exists")
    uid = db._uuid()
    db.users[uid] = {
        "id": uid,
        "email": payload.email,
        "name": payload.name,
        "role": "user",
        "password_hash": bcrypt.hash(payload.password),
        "created_at": db._now(),
        "updated_at": db._now(),
    }
    return success({"id": uid, "email": payload.email, "name": payload.name, "role": "user"})

# PUBLIC_INTERFACE
@router.post("/auth/login", summary="Login to get JWT token", response_model=dict)
def login(payload: LoginRequest):
    """Authenticate a user and return JWT.
    Returns:
      { success, data: { access_token, token_type }, meta }
    """
    user = None
    for u in db.users.values():
        if u["email"] == payload.email:
            user = u
            break
    if not user or not bcrypt.verify(payload.password, user["password_hash"]):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="Invalid credentials")
    token = create_access_token(sub=user["id"])
    return success(TokenResponse(access_token=token).model_dump())

# PUBLIC_INTERFACE
@router.get("/auth/me", summary="Current user info", response_model=dict)
def me(user_id: str = Depends(get_current_user)):
    """Get the current user's profile."""
    u = db.users.get(user_id)
    if not u:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="User not found")
    me_resp = MeResponse(id=u["id"], email=u["email"], name=u["name"], role=u["role"])
    return success(me_resp.model_dump())
