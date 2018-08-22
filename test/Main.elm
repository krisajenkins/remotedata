module Main exposing (main, tests)

import Legacy.ElmTest exposing (..)
import RemoteDataTest


tests : Test
tests =
    suite "All"
        [ RemoteDataTest.tests
        ]


main : Program Never () msg
main =
    runSuite tests
