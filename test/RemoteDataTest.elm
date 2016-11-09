module RemoteDataTest exposing (tests)

import Legacy.ElmTest exposing (..)
import RemoteData exposing (..)


tests : Test
tests =
    suite "RemoteData"
        [ mapTests
        , prismTests
        ]


mapTests : Test
mapTests =
    let
        check ( input, output ) =
            assertEqual output
                (map ((*) 3) input)
    in
        suite "map"
            <| List.map defaultTest
            <| List.map check
                [ ( Success 2, Success 6 )
                , ( NotAsked, NotAsked )
                , ( Loading, Loading )
                , ( Failure "error", Failure "error" )
                ]


prismTests : Test
prismTests =
    suite "webDataPrism"
        <| List.map defaultTest
            [ assertEqual (Just 5)
                (prism.getOption (prism.reverseGet 5))
            ]
