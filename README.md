# elm-check-io

[![Build Status](https://travis-ci.org/aluuu/elm-check-io.svg)](https://travis-ci.org/aluuu/elm-check-io)

[Elm-check](http://package.elm-lang.org/packages/TheSeamau5/elm-check/3.2.0) test runner with command-line interface using [IO](http://package.elm-lang.org/packages/maxsnew/IO/1.0.1).

## Getting started

Create `elm-check` test suite as you did it before:

```elm
import Check exposing (..)
import Check.Investigator exposing ( Investigator
                                   , investigator
                                   , rangeInt
                                   , float
                                   , int
                                   , char
                                   , shrink
                                   , random
                                   , lowerCaseChar
                                   , upperCaseChar
                                   )

dummySuite =
  suite "Dummy suite"
          [ claim "sum of two equal integers equals to its multiplication by 2"
          `true`
            (\num -> (num + num) == (2 * num))
          `for`
            int ]

result = quickCheck dummySuite
```

Then add IO-related imports and custom running part:

```elm
import Check.Runner.IO exposing (display)
import IO.IO exposing (..)
import IO.Runner exposing (Request, Response)
import IO.Runner as IO

run = display result >>= \success ->
      exit (if success then 0 else 1)

port responses : Signal Response

port requests : Signal Request
port requests = IO.run responses run
```

Fetch proper `elm-io.sh` script:

```shell
curl https://raw.githubusercontent.com/maxsnew/IO/1.0.1/elm-io.sh > elm-io.sh
```


Finally, we run it with the following commands:

```shell
elm-make --output test.js example/Test.elm
./elm-io.sh test.js test-io.js
node test-io.js
```

You'll get 0 exit code in case test run was successful and 1 otherwise. Additionally, test results would be showed in text form.

## Contributing

This project needs your help! Feedback and contributions are very welcome.
