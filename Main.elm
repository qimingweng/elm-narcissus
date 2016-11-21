import Html exposing (text, div)
import Html.Attributes
import Debug exposing (log)
import Narcissus exposing (inject, Style(..))
import List

-- Most of this code is here for testing on an elm-reactor for development

nest =
  [ StringStyle ("background-color", "red")
  ]

style =
  [ StringStyle ("background-color", "blue")
  , IntStyle ("height", 100)
  , NestedStyle (":hover", nest)
  , IntStyle ("width", 100)
  ]

blah = log "hello" (inject style)

main =
  div [Html.Attributes.class blah] [ text "Hello World" ]
