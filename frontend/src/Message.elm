module Message exposing (..)

import Url
import Browser

import CreateGame

type Msg = UrlChanged Url.Url | LinkClicked Browser.UrlRequest | CreateGameMsg CreateGame.Message

