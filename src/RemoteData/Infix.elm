module RemoteData.Infix
    exposing
        ( (<$>)
        , (<*>)
        )

{-| Convenience infix operators, for those that like them.

Allows you do define a "merge three values into a tuple" function as:

``` elm
merge3 a b c =
    (,,) <$> a <*> b <*> c
```

@docs (<$>)
@docs (<*>)
-}

import RemoteData exposing (RemoteData)


{-| Infix form of `map`. For those who like their applicative functors Haskell-style.
-}
(<$>) : (a -> b) -> RemoteData e a -> RemoteData e b
(<$>) =
    RemoteData.map


{-| Infix form of `(flip andMap)`. For those who like their applicative functors Haskell-style.


-}
(<*>) : RemoteData e (a -> b) -> RemoteData e a -> RemoteData e b
(<*>) =
    flip RemoteData.andMap
