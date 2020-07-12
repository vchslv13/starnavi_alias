module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Events exposing (onClick)
import Router
import Tuple exposing (..)
import Url
import Url.Builder exposing (absolute)

import CreateGame
import Message exposing (..)


type Model = CreateGame CreateGame.Model | GameLobby String Nav.Key | Unknown Nav.Key


main : Program () Model Msg
main = Browser.application
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    , onUrlChange = UrlChanged
    , onUrlRequest = LinkClicked
    }

urlToModel : Url.Url -> Nav.Key -> Model
urlToModel url =
    case Router.getRoute url of
        Router.CreateGame -> CreateGame << CreateGame.init
        Router.StartGame gameId -> GameLobby gameId
        Router.Unknown -> Unknown

init : () -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init _ url key = (urlToModel url key, Cmd.none)


view : Model -> Browser.Document Msg
view model = 
    case model of
        CreateGame pageModel ->
            let doc = CreateGame.view pageModel in
                { title = doc.title
                , body = List.map (Html.map CreateGameMsg) doc.body
                }
        GameLobby gameId _ ->
            { title = "Alias"
            , body =
                [ text <| "Magic! New game " ++ gameId ++ " here, see that, ha? I don't see it too :("]
            }

        Unknown _ ->
            { title = "Alias"
            , body =
                [ text "Ain't got no pages like that. Don't joke with me"]
            }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = let navKey = getNavKey model in
    case ( msg, model ) of
        ( CreateGameMsg subMsg, CreateGame subModel ) ->
            mapFirst CreateGame <| mapSecond (Cmd.map CreateGameMsg) <| CreateGame.update subMsg subModel
        (UrlChanged url, _) -> (urlToModel url navKey, Cmd.none)
        ( _, _ ) -> ( model, Cmd.none )


getNavKey: Model -> Nav.Key
getNavKey model =
    case model of
        CreateGame pageModel -> pageModel.navKey
        GameLobby _ navKey -> navKey
        Unknown navKey -> navKey


subscriptions : Model -> Sub Msg
subscriptions _ = Sub.none

