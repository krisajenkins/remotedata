module RemoteDataTest exposing (tests)

import Legacy.ElmTest exposing (..)
import RemoteData exposing (..)


tests : Test
tests =
    suite "RemoteData"
        [ mapTests
        , andMapTests
        , mapBothTests
        , prismTests
        , fromListTests
        , fromMaybeTests
        ]


mapTests : Test
mapTests =
    let
        check ( input, output ) =
            assertEqual output
                (map ((*) 3) input)
    in
    suite "map" <|
        List.map defaultTest <|
            List.map check
                [ ( Success 2, Success 6 )
                , ( NotAsked, NotAsked )
                , ( Loading, Loading )
                , ( Failure "error", Failure "error" )
                ]


mapBothTests : Test
mapBothTests =
    let
        check ( input, output ) =
            assertEqual output
                (mapBoth ((*) 3) ((++) "error") input)
    in
    suite "mapBoth" <|
        List.map defaultTest <|
            List.map check
                [ ( Success 2, Success 6 )
                , ( NotAsked, NotAsked )
                , ( Loading, Loading )
                , ( Failure "", Failure "error" )
                ]


prismTests : Test
prismTests =
    suite "webDataPrism" <|
        List.map defaultTest
            [ assertEqual (Just 5)
                (prism.getOption (prism.reverseGet 5))
            ]


andMapTests : Test
andMapTests =
    suite "andMap" <|
        List.map defaultTest
            [ assertEqual (andMap (Success 5) (Success ((*) 2))) (Success 10)
            , assertEqual (andMap (Failure "nope") Loading) (Failure "nope")
            , assertEqual (andMap Loading (Failure "nope")) (Failure "nope")
            ]

fromListTests : Test
fromListTests =
    suite "fromList" <|
        List.map defaultTest
            [ assertEqual (fromList []) (Success [])
            , assertEqual (fromList [Success 1]) (Success [1])
            , assertEqual (fromList [Success 1, Success 2]) (Success [1, 2])
            , assertEqual (fromList [NotAsked, Loading]) (Loading)
            , assertEqual (fromList [Success 1, Loading]) (Loading)
            , assertEqual (fromList [Success 1, Loading, Failure "nope"]) (Failure "nope")
            , assertEqual (fromList [Success 1, Failure "nah", Success 2, Failure "nope"]) (Failure "nah")
            ]


fromMaybeTests : Test
fromMaybeTests =
    suite "fromMaybe" <|
        List.map defaultTest
            [ assertEqual (fromMaybe "Should be 1" (Just 1)) (Success 1)
            , assertEqual (fromMaybe "Should be 1" Nothing) (Failure "Should be 1")
            , assertEqual (fromMaybe "fail" (Just [ 1, 2, 3 ])) (Success [ 1, 2, 3 ])
            , assertEqual (fromMaybe "fail" Nothing) (Failure "fail")
            ]
