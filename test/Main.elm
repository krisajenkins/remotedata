module Main exposing (..)

import ElmTest exposing (..)
import RemoteDataTest


tests : Test
tests =
    suite "All"
        [ RemoteDataTest.tests
        ]


main : Program Never
main =
    runSuite tests
