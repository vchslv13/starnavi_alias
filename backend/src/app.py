from aiohttp import web
from pydantic import ValidationError

from . import game, models

routes = web.RouteTableDef()


@routes.post('/api/games')
async def create_game(request: web.Request):
    try:
        game_settings = models.GameSettingsRequest(**await request.json())
    except ValidationError as err:
        return web.json_response(err.json(), status=400)

    new_game = game.Game(game_settings.players_in_team)
    request.app['games'].append(new_game)

    response_data = models.Game.from_orm(new_game).dict()
    return web.json_response(response_data)


@routes.get('/{path:.*}')
async def serve_frontend(request):
    # quick hack for easier development
    return web.FileResponse('/home/slava/projects/starnavi-alias/frontend/index.html')


app = web.Application()
app.add_routes(routes)
app['games'] = list()

if __name__ == '__main__':
    web.run_app(app)
