module CreateGame exposing (Model, Message, init, update, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)

type Field a = Value a | ErrorInput String
type alias Model = { navKey: Nav.Key, playersInTeam: Field Int}
type Message = CreateGameClick | PlayersInTeam String


init : Nav.Key -> Model
init key = { navKey = key, playersInTeam = Value 2 }


update : Message -> Model -> (Model, Cmd Message)
update msg model =
    case msg of
        PlayersInTeam value ->
            case String.toInt value of
                Just result -> ( { model | playersInTeam = Value result }, Cmd.none )
                Nothing -> ( { model | playersInTeam = ErrorInput value }, Cmd.none )
        CreateGameClick -> (model, Nav.pushUrl model.navKey "/start-game")



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

