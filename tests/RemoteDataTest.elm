module RemoteDataTest exposing (suite)

import Debug exposing (toString)
import Expect
import RemoteData exposing (..)
import RemoteData.Data as Data exposing (Data(..))
import Test exposing (Test, describe, test)


suite : Test
suite =
    describe "The RemoteData module"
        [ mapTests
        , andMapTests
        , mapBothTests
        , unwrapTests
        , unpackTests
        , prismTests
        , fromListTests
        , fromMaybeTests
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
            [ ( "Loading Success", Loading (Success 2), Loading (Success 6) )
            , ( "Final NoData", Final NoData, Final NoData )
            , ( "Loading Error w. data", Loading (Failure "error" (Just 2)), Loading (Failure "error" (Just 6)) )
            ]


mapBothTests : Test
mapBothTests =
    let
        check ( label, input, output ) =
            test label <|
                \_ ->
                    mapBoth ((*) 3) ((++) "error") input
                        |> Expect.equal output
    in
    describe "mapBoth" <|
        List.map check
            [ ( "Final Success", Final <| Success 2, Final <| Success 6 )
            , ( "Loading NoData", Loading NoData, Loading NoData )
            , ( "Final Failure w data", Final <| Failure "" (Just 2), Final <| Failure "error" (Just 6) )
            , ( "Loading Failure w/o data", Loading <| Failure "" Nothing, Loading <| Failure "error" Nothing )
            ]


unwrapTests : Test
unwrapTests =
    let
        check ( input, output ) =
            test (toString input) <|
                \_ ->
                    Expect.equal output
                        (unwrap 7 ((*) 3) input)
    in
    describe "unwrap" <|
        List.map check
            [ ( Final <| Success 2, 6 )
            , ( Final <| NoData, 7 )
            , ( Loading <| Failure "error" (Just 2), 6 )
            , ( Loading <| Failure "error" Nothing, 7 )
            ]


unpackTests : Test
unpackTests =
    let
        check ( input, output ) =
            test (toString input) <|
                \_ ->
                    Expect.equal output
                        (unpack (always 7) ((*) 3) input)
    in
    describe "unpack" <|
        List.map check
            [ ( Final <| Success 2, 6 )
            , ( Final <| NoData, 7 )
            , ( Loading <| Failure "error" (Just 2), 6 )
            , ( Loading <| Failure "error" Nothing, 7 )
            ]


prismTests : Test
prismTests =
    test "webDataPrism" <|
        \_ ->
            prism.getOption (prism.reverseGet 5)
                |> Expect.equal (Just 5)


andMapTests : Test
andMapTests =
    let
        check ( label, output, expected ) =
            test label <|
                \_ ->
                    Expect.equal expected output
    in
    describe "andMap" <|
        List.map check
            [ ( "Final Success case"
              , andMap (Final <| Success 5) (Final <| Success ((*) 2))
              , Final <| Success 10
              )
            , ( "Loading Success case 1"
              , andMap (Final <| Success 5) (Loading <| Success ((*) 2))
              , Loading <| Success 10
              )
            , ( "Loading Success case 2"
              , andMap (Loading <| Success 5) (Final <| Success ((*) 2))
              , Loading <| Success 10
              )
            , ( "Failure case 1"
              , andMap (Loading <| Failure "nope" Nothing) (Final <| Success ((*) 2))
              , Loading <| Failure "nope" Nothing
              )
            , ( "Failure case 2"
              , andMap (Final <| Failure "nope" (Just 5)) (Loading <| Failure "doh" (Just ((*) 2)))
              , Loading <| Failure "doh" (Just 10)
              )
            ]


fromListTests : Test
fromListTests =
    let
        check ( label, output, expected ) =
            test label <|
                \_ ->
                    Expect.equal expected output
    in
    describe "fromList" <|
        List.map check
            [ ( "Success from empty", fromList [], fromValue [] )
            , ( "Success from singleton"
              , fromList [ fromValue 1 ]
              , fromValue [ 1 ]
              )
            , ( "Success from list with many values"
              , fromList [ fromValue 1, fromValue 2 ]
              , fromValue [ 1, 2 ]
              )
            , ( "Loading from list with Loading and no Failure 1"
              , fromList [ Final NoData, Loading NoData ]
              , Loading NoData
              )
            , ( "Loading from list with Loading and no Failure 2"
              , fromList [ fromValue 1, Loading NoData ]
              , Loading NoData
              )
            , ( "Failure from list with Failure1"
              , fromList [ fromValue 1, Loading NoData, Final <| Failure "nope" Nothing ]
              , Loading <| Failure "nope" Nothing
              )
            , ( "Failure from list with Failure 2"
              , fromList [ fromValue 1, Final <| Failure "nah" (Just 4), fromValue 2, Final <| Failure "nope" Nothing ]
              , Final <| Failure "nah" Nothing
              )
            ]


fromMaybeTests : Test
fromMaybeTests =
    let
        check ( label, output, expected ) =
            test label <|
                \_ ->
                    Expect.equal expected output
    in
    describe "fromMaybe"
        [ check
            ( "Just to Success 1"
            , fromMaybe "Should be 1" (Just 1)
            , fromValue 1
            )
        , check
            ( "Nothing to Failure 1"
            , fromMaybe "Should be 1" Nothing
            , Final <| Failure "Should be 1" Nothing
            )
        , check
            ( "Just to Success 2"
            , fromMaybe "fail" (Just [ 1, 2, 3 ])
            , fromValue [ 1, 2, 3 ]
            )
        , check
            ( "Nothing to Failure 2"
            , fromMaybe "fail" Nothing
            , Final <| Failure "fail" Nothing
            )
        ]
