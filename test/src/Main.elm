module Main exposing (main)

-- import Runner.Log
-- import RemoteDataTest

import Browser
import Html


main : Program () () ()
main =
    -- let
    --     _ =
    --         Runner.Log.run RemoteDataTest.all
    -- in
    Browser.staticPage (Html.text "")
