module Router exposing (Route(..), getRoute)

import Url
import Url.Parser exposing (..)


type Route = CreateGame | StartGame String | Unknown


getRoute : Url.Url -> Route
getRoute url = case parse route url of
    Just x -> x
    Nothing -> Unknown

route : Parser (Route -> a) a
route = oneOf
    [ map CreateGame top
    , map StartGame <| s "start-game" </> string
    ]

