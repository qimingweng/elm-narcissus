# elm-narcissus

Inline Styles for Elm, using narcissus.

This package allows you to add inline styles, including hover, and pseudo properties to Elm HTML elements without having to worry about generating CSS files, including `<style>` tags in HTML files, etc...

Some of the benefits include:

- Does not generate CSS files
- Supports media queries
- Supports pseudo selectors :hover
- Supports child selectors .parent .child { ... }
- Small in size

Read more about narcissus on its [docs](https://github.com/qimingweng/narcissus).

## Theory

Please see the [narcissus documentation](https://github.com/qimingweng/narcissus#how-does-narcissus-work-a-story) for the basic theory about how this works for Javascript. This package acts as a wrapper for the Javascript package so that narcissus can be used in Elm.

## Usage

Essentially, `Narcissus.inject` takes a `List Styles`, injects the styles into the web page and returns a class name as a `String`.

```elm
style : List Style
style =
  [ StringStyle ( "backgroundColor", "blue" )
  , StringStyle ( "lineHeight", "12px" )
  , IntStyle ( "height", 20 )
  , NestedStyle ( "&&:hover", [ StringStyle ( "backgroundColor", "pink" ) ] )
  ]

main = div [ class (Narcissus.inject style) ] [ text "Hello World" ]
```

`elm-narcissus` defines the type Style as:

```elm
type Style
  = StringStyle (String, String)
  | IntStyle (String, Int)
  | NestedStyle (String, List Style)
```

Through these three types, `elm-narcissus` can essentially map to any of the [examples here](https://github.com/qimingweng/narcissus#plain-object-documentation).

## Help

Send me a message on twitter [@qiming](https://twitter.com/qiming), or open an issue.

## Development

Unfortunately, I need to include the "compiled" Javascript code for the Native narcissus module in this repository. The elm-packager seems to read off of github code alone, and so the compiled code must be checked in. The original Javascript can be found in `NativeNarcissusOriginal.js` in the root repository. I have not included the webpack setup code in this repository to save space for anyone downloading this package.
