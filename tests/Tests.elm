module Tests exposing (all)

import Test exposing (..)
import Expect
import RemoteData exposing (..)


all : Test
all =
    describe "RemoteData"
        [ mapTests
        , prismTests
        ]


mapTests : Test
mapTests =
    let
        check ( input, output ) =
            test "map test" <|
                \() ->
                    Expect.equal output
                        (map ((*) 3) input)
    in
        describe "map" <|
            List.map check
                [ ( Success 2, Success 6 )
                , ( NotAsked, NotAsked )
                , ( Loading, Loading )
                , ( Failure "error", Failure "error" )
                ]


prismTests : Test
prismTests =
    describe "webDataPrism" <|
        [ test "prism" <|
            \() -> Expect.equal (Just 5) (prism.getOption (prism.reverseGet 5))
        ]
