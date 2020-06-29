module CreateGame exposing (Model, Message, view)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Events exposing (onClick)


type alias Model = {navKey: Nav.Key}
type Message = CreateGameClick

view : Model -> Browser.Document Message
view model =
    { title = "Alias"
    , body =
        [ text "Game creation page"
        , button [onClick CreateGameClick] [text "Create game"]
        ]
    }

