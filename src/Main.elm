module Main exposing (Model, Msg(..), main)

import Browser exposing (Document)
import Html exposing (Html, button, div, h1, li, text, textarea, ul)
import Html.Attributes exposing (class, placeholder, rows)
import Html.Events exposing (onClick, onInput)
import List
import Random
import Random.List
import String


main : Program () Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }


type alias Model =
    { participants : List String
    , assignment : List ( String, String )
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model [] []
    , Cmd.none
    )


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
            List.map2 Tuple.pair l (xs ++ [ x ])

        [] ->
            []


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Document Msg
view model =
    Document "Secret Santa" [ body model ]


body : Model -> Html Msg
body model =
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
