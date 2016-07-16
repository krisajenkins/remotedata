module Main exposing (..)

import ElmTest exposing (..)


tests : Test
tests =
    suite "All"
        []


main : Program Never
main =
    runSuite tests
