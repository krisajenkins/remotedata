# Changelog

## 4.0.0

Changes inline with the Elm 0.18 release.

* The order the arguments for `andThen` are flipped.

## 3.0.0

Changes inline with the Elm 0.18 release.

* `apply` was renamed to `andMap`, and the argument order was flipped for easier chaining with `|>`. This follows the new Elm 0.18 convention.
* `($)` and `(*)` were moved to `RemoteData.Infix`.
* `pure` became `succeed`, to fall in line with Elm core.
* `mapFailure` became `mapError`, to fall in line with Elm core.
* `fromTask` no longer exists, following changes to the underling `Task` API.
