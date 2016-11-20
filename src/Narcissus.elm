module Narcissus exposing (Style(..), inject)

{-| This package allows you to add inline styles, including hover, and pseudo
properties to Elm HTML elements without having to worry about generating CSS
files, including `<style>` tags in HTML files, etc...

# Inject
@docs inject
# Using Styles
@docs Style
-}

import Native.Narcissus

{-| Represents a style. For example, a `StringStyle` might be the tuple
`("backgroundColor", "blue")`, an `IntStyle` might be the tuple `("height", 20)`
and a `NestedStyle` takes keys that usually look like "&&:hover" or "&& .child"
-}
type Style
  = StringStyle (String, String)
  | IntStyle (String, Int)
  | NestedStyle (String, List Style)

{-| Takes a list of styles and injects them to the document. It returns a
`String` class name that is meant to be used with `Html`, for example

    main = div [ class (inject styles) ] [ text "Hello World" ]
-}
inject : List Style -> String
inject = Native.Narcissus.inject
