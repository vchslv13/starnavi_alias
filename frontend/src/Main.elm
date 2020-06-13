module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Events exposing (onClick)
import Url
import Url.Builder exposing (absolute)


type Page = CreateGame | GameLobby | Unknown
type alias Model = {page: Page, navKey: Nav.Key}

type Msg = UrlChanged Url.Url | LinkClicked Browser.UrlRequest | CreateGameMsg


main : Program () Model Msg
main = Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }

pathToPage : String -> Page
pathToPage path =
    case path of
        "/" -> CreateGame
        "/start-game" -> GameLobby
        _ -> Unknown

init : () -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init _ url key = ({page = pathToPage url.path, navKey = key}, Cmd.none)


view : Model -> Browser.Document Msg
view model = 
    case model.page of
        CreateGame -> 
            { title = "Alias"
            , body = 
                [ text "Game creation page"
                , button [onClick CreateGameMsg] [text "Create game"]
                ]
            }    

        GameLobby ->
            { title = "Alias"
            , body =
                [ text "Magic! New game here, see that, ha? I don't see it too :("]
            }

        Unknown ->
            { title = "Alias"
            , body =
                [ text "Ain't got no pages like that. Don't joke with me"]
            }


update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
    case msg of
        CreateGameMsg -> ({model| page = GameLobby}, Nav.pushUrl model.navKey "/start-game")
        UrlChanged _ -> (model, Cmd.none)
        LinkClicked _ -> (model, Cmd.none)


subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none

