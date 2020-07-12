module CreateGame exposing (Model, Message, init, update, view)

import Browser
import Browser.Navigation as Nav
import Json.Decode as JD
import Json.Encode as JE
import Html exposing (..)
import Http
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)

type Field a = Value a | ErrorInput String
type alias Model = { navKey: Nav.Key, playersInTeam: Field Int}
type Message = CreateGameClick | PlayersInTeam String | CreatedGame (Result Http.Error String)


init : Nav.Key -> Model
init key = { navKey = key, playersInTeam = Value 2 }


update : Message -> Model -> (Model, Cmd Message)
update msg model =
    case msg of
        PlayersInTeam value ->
            case String.toInt value of
                Just result -> ( { model | playersInTeam = Value result }, Cmd.none )
                Nothing -> ( { model | playersInTeam = ErrorInput value }, Cmd.none )
        CreateGameClick ->
            case model.playersInTeam of
                Value value -> (model, createNewGame value)
                ErrorInput _ -> (model, Cmd.none)  -- just skip sending any request as for now
        CreatedGame result ->
            case result of
                Ok gameId -> (model, Nav.pushUrl model.navKey <| "/start-game/" ++ gameId)
                Err _ -> (model, Cmd.none)


createNewGame : Int -> Cmd Message
createNewGame playersInTeam = Http.post
    { url = "/api/games"
    , body = Http.jsonBody <| JE.object [("players_in_team", JE.int playersInTeam)]
    , expect = Http.expectJson CreatedGame (JD.field "id" JD.string)
    }



view : Model -> Browser.Document Message
view model =
    { title = "Alias"
    , body =
        [ text "Game creation page"
        , div []
            [ label [ for "players-in-team" ] [ text "Players in team:" ]
            , showPlayersInput model.playersInTeam
            ]
        , button [ onClick CreateGameClick] [ text "Create game" ]
        ]
    }

showPlayersInput : Field Int -> Html Message
showPlayersInput userInput =
    case userInput of
        Value val ->
            input
                [ id "players-in-team"
                , name "players-in-team"
                , type_ "number"
                , value (String.fromInt val)
                , onInput PlayersInTeam
                ]
                []
        ErrorInput val ->
            input
                [ id "players-in-team"
                , name "players-in-team"
                , type_ "number"
                , value val
                , onInput PlayersInTeam
                , style "border-color" "#900"
                , style "background-color" "#FDD"
                ]
                []

