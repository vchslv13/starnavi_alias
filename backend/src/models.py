from typing import List
from pydantic import BaseModel


class GameSettingsRequest(BaseModel):
    players_in_team: int


class Player(BaseModel):
    id: str

    class Config:
        orm_mode = True


class Team(BaseModel):
    players: List[Player]

    class Config:
        orm_mode = True


class Game(BaseModel):
    id: str
    team_a: Team
    team_b: Team

    class Config:
        orm_mode = True
