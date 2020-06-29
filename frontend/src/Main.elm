module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Events exposing (onClick)
import Url
import Url.Builder exposing (absolute)

import CreateGame
import Message exposing (..)


type Model = CreateGame CreateGame.Model | GameLobby Nav.Key | Unknown Nav.Key


main : Program () Model Msg
main = Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }

pathToModel : String -> Nav.Key -> Model
pathToModel path =
    case path of
        "/" -> CreateGame << CreateGame.Model
        "/start-game" -> GameLobby
        _ -> Unknown

init : () -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init _ url key = ((pathToModel url.path) key, Cmd.none)


view : Model -> Browser.Document Msg
view model = 
    case model of
        CreateGame pageModel ->
            let doc = CreateGame.view pageModel in
                { title = doc.title
                , body = List.map (Html.map CreateGameMsg) doc.body
                }
        GameLobby _ ->
            { title = "Alias"
            , body =
                [ text "Magic! New game here, see that, ha? I don't see it too :("]
            }

        Unknown _ ->
            { title = "Alias"
            , body =
                [ text "Ain't got no pages like that. Don't joke with me"]
            }


update : Msg -> Model -> (Model, Cmd Msg)
update msg model = let navKey = getNavKey model in
    case msg of
        CreateGameMsg _ -> (GameLobby navKey, Nav.pushUrl navKey "/start-game")
        UrlChanged _ -> (model, Cmd.none)
        LinkClicked _ -> (model, Cmd.none)

getNavKey: Model -> Nav.Key
getNavKey model =
    case model of
        CreateGame pageModel -> pageModel.navKey
        GameLobby navKey -> navKey
        Unknown navKey -> navKey

subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none

