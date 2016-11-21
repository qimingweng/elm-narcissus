module Narcissus exposing (Style(..), inject)

{-| This package allows you to add inline styles, including hover, and pseudo
properties to Elm HTML elements without having to worry about generating CSS
files, including `<style>` tags in HTML files, etc...
# Inject
@docs inject
# Using Styles
@docs Style
-}

import Debug exposing (log)
import List
import Set
import Murmur3
import Native.Narcissus

{-| Represents a style. For example, a `StringStyle` might be the tuple
`("backgroundColor", "blue")`, an `IntStyle` might be the tuple `("height", 20)`
and a `NestedStyle` takes keys that usually look like "&&:hover" or "&& .child"
-}
type Style
  = StringStyle (String, String)
  | IntStyle (String, Int)
  | NestedStyle (String, List Style)

injectIntoStyleTag : String -> Bool
injectIntoStyleTag = Native.Narcissus.injectIntoStyleTag

{-| Takes a list of styles and injects them to the document. It returns a
`String` class name that is meant to be used with `Html`, for example
    main = div [ class (inject styles) ] [ text "Hello World" ]
-}
inject : List Style -> String
inject list =
  let
    class = hashStyle list
    styleAsString = toCSSString list class

    _ = log "styleString" styleAsString

    _ = injectIntoStyleTag styleAsString
  in
    class

-- Serialize a list of styles into a string, so that it can be hashed
serialize : List Style -> String
serialize list =
  let
    folder current prev =
      let
        serialized =
          case current of
            StringStyle (name, value) ->
              name ++ ":" ++ value
            IntStyle (name, num) ->
              name ++ ":" ++ toString num
            NestedStyle (name, nest) ->
              name ++ ":{" ++ serialize nest ++ "}"
      in
        "," ++ serialized ++ prev
  in
    List.foldr folder "" list

hashStyle : List Style -> String
hashStyle list =
  let
    number = serialize list
      |> Murmur3.hashString 664988
      |> toString
  in
    "narcissus_" ++ number

isMain : Style -> Bool
isMain rule =
  case rule of
    StringStyle (_, _) ->
      True
    IntStyle (_, _) ->
      True
    NestedStyle (_, _) ->
      False

-- A constant false for now, we will implement laters
isMedia : Style -> Bool
isMedia rule = False

isNested rule =
  case rule of
    StringStyle (_, _) ->
      False
    IntStyle (_, _) ->
      False
    NestedStyle (_, _) ->
      True

toCSSString : List Style -> String -> String
toCSSString list class =
  let
    main = List.filter isMain list
    media = List.filter isMedia list
    nested = List.filter isNested list

    mainString = "." ++ class ++ (generateFromSimpleRules main)
    mediaString = ""
    nestedString = generateNestedString class nested
  in
    mainString ++ mediaString ++ nestedString

-- A map of all the styles that should have px added to them
unitlessNumbers = Set.fromList
  [ "animation-iteration-count"
  , "border-image-outset"
  , "border-image-slice"
  , "border-image-width"
  , "box-flex"
  , "box-flex-group"
  , "box-ordinal-group"
  , "column-count"
  , "flex"
  , "flex-grow"
  , "flex-positive"
  , "flex-shrink"
  , "flex-negative"
  , "flex-order"
  , "grid-row"
  , "grid-column"
  , "font-weight"
  , "line-clamp"
  , "line-height"
  , "opacity"
  , "order"
  , "orphans"
  , "tab-size"
  , "widows"
  , "z-index"
  , "zoom"
  , "fill-opacity"
  , "flood-opacity"
  , "stop-opacity"
  , "stroke-dasharray"
  , "stroke-dashoffset"
  , "stroke-miterlimit"
  , "stroke-opacity"
  , "stroke-width"
  ]

-- TODO: make sure we only add to pixels things that shoud not be unitless
maybePixels : String -> String
maybePixels name =
  if Set.member name unitlessNumbers then
    ""
  else
    "px"

-- List of only StringStyle or IntStyle
generateFromSimpleRules list =
  let
    reduce next memo =
      case next of
        StringStyle (name, value) ->
          memo ++ name ++ ":" ++ value ++ ";"
        IntStyle (name, num) ->
          memo ++ name ++ ":" ++ (toString num) ++ (maybePixels name) ++ ";"
        NestedStyle (_, _) ->
          memo
    body = List.foldl reduce "" list
  in
    "{" ++ body ++ "}"

generateNestedString : String -> List Style -> String
generateNestedString class list =
  let
    reduce next memo =
      case next of
        StringStyle (_, _) ->
          memo
        IntStyle (_, _) ->
          memo
        NestedStyle (suffix, rules) ->
          "." ++ class ++ suffix ++ (generateFromSimpleRules rules)
    body = List.foldl reduce "" list
  in
    body
