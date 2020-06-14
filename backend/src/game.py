from uuid import uuid4


class Player:
    def __init__(self):
        self.id = str(uuid4())


class Team:
    def __init__(self, players_in_team: int):
        self.players = [Player() for _ in range(players_in_team)]


class Game:
    """ Handle game logic. """

    def __init__(self, players_in_team: int):
        self.id = str(uuid4())
        self.team_a = Team(players_in_team)
        self.team_b = Team(players_in_team)
