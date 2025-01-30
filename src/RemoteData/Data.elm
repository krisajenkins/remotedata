module RemoteData.Data exposing
    ( Data(..)
    , andMap
    , fail
    , fromMaybe
    , map
    , mapError
    , succeed
    , toMaybe
    , withDefault
    )

{-| A data can have three different states:

  - `Nothing` - No data available, at all
  - `Failure` - Something went wrong when loadin. Here's the error.
    The former value is still accessible if any.
  - `Success` - Everything worked, and here's the data.

-}


type Data e a
    = NoData
    | Success a
    | Failure e (Maybe a)


succeed : a -> Data e a
succeed data =
    Success data


fail : e -> Data e a -> Data e a
fail error data =
    Failure error (toMaybe data)


withDefault : a -> Data e a -> a
withDefault default =
    toMaybe >> Maybe.withDefault default


fromMaybe : Maybe a -> Data e a
fromMaybe value =
    case value of
        Just a ->
            Success a

        Nothing ->
            NoData


toMaybe : Data e a -> Maybe a
toMaybe data =
    case data of
        Success x ->
            Just x

        Failure _ (Just x) ->
            Just x

        _ ->
            Nothing


map : (a -> b) -> Data e a -> Data e b
map f data =
    case data of
        NoData ->
            NoData

        Success a ->
            Success (f a)

        Failure e a ->
            Failure e (Maybe.map f a)


andMap : Data e a -> Data e (a -> b) -> Data e b
andMap wrappedValue wrappedFunction =
    case ( wrappedFunction, wrappedValue ) of
        ( Success f, Success value ) ->
            Success (f value)

        ( Success f, Failure error (Just value) ) ->
            Failure error (Just (f value))

        ( Success _, Failure error Nothing ) ->
            Failure error Nothing

        ( Failure error (Just f), Success value ) ->
            Failure error (Just (f value))

        ( Failure error (Just f), Failure _ (Just value) ) ->
            Failure error (Just (f value))

        ( Failure error _, _ ) ->
            Failure error Nothing

        ( NoData, Failure error _ ) ->
            Failure error Nothing

        ( _, NoData ) ->
            NoData

        ( NoData, _ ) ->
            NoData


mapError :
    (e -> f)
    -> Data e a
    -> Data f a
mapError f data =
    case data of
        Failure err x ->
            Failure (f err) x

        Success x ->
            Success x

        NoData ->
            NoData
