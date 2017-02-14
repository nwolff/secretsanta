module Main exposing (..)

import Html exposing (div, button, text, textarea, Html, ul, li, h1)
import Html.Attributes exposing (class, rows, placeholder)
import Html.Events exposing (onClick, onInput)
import Html exposing (program)
import List
import Random
import Random.List
import String


main : Program Never Model Msg
main =
    program { init = ( model, Cmd.none ), update = update, subscriptions = subscriptions, view = view }


type alias Model =
    { participants : List String
    , assignment : List ( String, String )
    }


model : Model
model =
    Model [] []


type Msg
    = Names String
    | Go
    | Assign (List String)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Names names ->
            let
                participants =
                    String.lines names
                        |> List.map String.trim
                        |> List.filter (not << String.isEmpty)
            in
                ( { model | participants = participants }, Cmd.none )

        Go ->
            ( model, Random.generate Assign (Random.List.shuffle model.participants) )

        Assign randomlyOrderedParticipants ->
            ( { model | assignment = pairsWrapping randomlyOrderedParticipants }, Cmd.none )


pairsWrapping : List a -> List ( a, a )
pairsWrapping l =
    case l of
        x :: xs ->
            List.map2 (,) l (xs ++ [ x ])

        [] ->
            []


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ div [ class "secret-santa" ]
            [ h1 [] [ text "Will help you randomly decide who should give presents to who." ]
            , div []
                [ textarea [ class "form-control", rows 10, placeholder "Player names, one on each line", onInput Names ] [] ]
            , div []
                [ button [ class "btn btn-primary", onClick Go ] [ text "Let's go" ] ]
            , ul []
                (List.map (\( a, b ) -> li [] [ text (a ++ "->" ++ b) ]) model.assignment)
            ]
        ]
