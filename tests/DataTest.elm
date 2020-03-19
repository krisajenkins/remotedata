module DataTest exposing (suite)

import Expect
import RemoteData.Data as Data exposing (..)
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "The RemoteData.Data module"
        [ succeedTests
        , failTests
        , withDefaultTests
        , fromMaybeTests
        , toMaybeTests
        , mapTests
        , andMapTests
        , mapErrorTests
        ]


succeedTests : Test
succeedTests =
    test "succeed" <| \_ -> succeed 3 |> Expect.equal (Success 3)


failTests : Test
failTests =
    let
        check ( label, input, output ) =
            test label <|
                \_ ->
                    fail "error" input
                        |> Expect.equal output
    in
    describe "fail" <|
        List.map check
            [ ( "NoData", NoData, Failure "error" Nothing )
            , ( "Success", Success 2, Failure "error" (Just 2) )
            , ( "Failure w data", Failure "smthg" (Just 2), Failure "error" (Just 2) )
            , ( "Failure w/o data", Failure "smthg" Nothing, Failure "error" Nothing )
            ]


withDefaultTests : Test
withDefaultTests =
    let
        check ( label, input, output ) =
            test label <|
                \_ ->
                    withDefault 5 input
                        |> Expect.equal output
    in
    describe "withDefault" <|
        List.map check
            [ ( "Success", Success 2, 2 )
            , ( "NoData", NoData, 5 )
            , ( "Failure w data", Failure "error" (Just 2), 2 )
            , ( "Failure w/o data", Failure "error" Nothing, 5 )
            ]


fromMaybeTests : Test
fromMaybeTests =
    let
        check ( label, input, output ) =
            test label <|
                \_ ->
                    fromMaybe input
                        |> Expect.equal output
    in
    describe "fromMaybe" <|
        List.map check
            [ ( "Success", Just 2, Success 2 )
            , ( "NoData", Nothing, NoData )
            ]


toMaybeTests : Test
toMaybeTests =
    let
        check ( label, input, output ) =
            test label <|
                \_ ->
                    toMaybe input
                        |> Expect.equal output
    in
    describe "toMaybe" <|
        List.map check
            [ ( "Success", Success 2, Just 2 )
            , ( "NoData", NoData, Nothing )
            , ( "Failure w data", Failure "error" (Just 2), Just 2 )
            , ( "Failure w/o data", Failure "error" Nothing, Nothing )
            ]


mapTests : Test
mapTests =
    let
        check ( label, input, output ) =
            test label <|
                \_ ->
                    map ((*) 3) input
                        |> Expect.equal output
    in
    describe "map" <|
        List.map check
            [ ( "Success", Success 2, Success 6 )
            , ( "NoData", NoData, NoData )
            , ( "Failure w data", Failure "error" (Just 2), Failure "error" (Just 6) )
            , ( "Failure w/o data", Failure "error" Nothing, Failure "error" Nothing )
            ]


andMapTests : Test
andMapTests =
    let
        check ( label, ( fn, value ), output ) =
            test label <|
                \_ ->
                    fn
                        |> andMap value
                        |> Expect.equal output
    in
    describe "andMap" <|
        List.map check
            [ ( "NoData/Success", ( NoData, Success 2 ), NoData )
            , ( "NoData/NoData", ( NoData, NoData ), NoData )
            , ( "NoData/Failure w Data"
              , ( NoData, Failure "err" (Just 2) )
              , Failure "err" Nothing
              )
            , ( "NoData/Failure w/o Data"
              , ( NoData, Failure "err" Nothing )
              , Failure "err" Nothing
              )
            , ( "Success/Success"
              , ( Success ((*) 2), Success 2 )
              , Success 4
              )
            , ( "Success/NoData"
              , ( Success ((*) 2), NoData )
              , NoData
              )
            , ( "Success/Failure w Data"
              , ( Success ((*) 2), Failure "err" (Just 2) )
              , Failure "err" (Just 4)
              )
            , ( "Success/Failure w/o Data"
              , ( Success ((*) 2), Failure "err" Nothing )
              , Failure "err" Nothing
              )
            , ( "Failure w Data/Success"
              , ( Failure "err" (Just ((*) 2)), Success 2 )
              , Failure "err" (Just 4)
              )
            , ( "Failure w Data/NoData"
              , ( Failure "err" (Just ((*) 2)), NoData )
              , Failure "err" Nothing
              )
            , ( "Failure w Data/Failure w Data"
              , ( Failure "err" (Just ((*) 2)), Failure "err2" (Just 2) )
              , Failure "err" (Just 4)
              )
            , ( "Failure w Data/Failure w/o Data"
              , ( Failure "err" (Just ((*) 2)), Failure "err2" Nothing )
              , Failure "err" Nothing
              )
            , ( "Failure w/o Data/Success"
              , ( Failure "err" Nothing, Success 2 )
              , Failure "err" Nothing
              )
            , ( "Failure w/o Data/NoData"
              , ( Failure "err" Nothing, NoData )
              , Failure "err" Nothing
              )
            , ( "Failure w/o Data/Failure w Data"
              , ( Failure "err" Nothing, Failure "err2" (Just 2) )
              , Failure "err" Nothing
              )
            , ( "Failure w/o Data/Failure w/o Data"
              , ( Failure "err" Nothing, Failure "err2" Nothing )
              , Failure "err" Nothing
              )
            ]


mapErrorTests : Test
mapErrorTests =
    let
        check ( label, input, output ) =
            test label <|
                \_ ->
                    input
                        |> mapError ((++) "_")
                        |> Expect.equal output
    in
    describe "mapError" <|
        List.map check
            [ ( "NoData", NoData, NoData )
            , ( "Success", Success 2, Success 2 )
            , ( "Failure w data", Failure "err" (Just 2), Failure "_err" (Just 2) )
            , ( "Failure w/o data", Failure "err" Nothing, Failure "_err" Nothing )
            ]
