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
import Check.Runner.IO exposing (display)

import IO.IO exposing (..)
import IO.Runner exposing (Request, Response)
import IO.Runner as IO

dummySuite =
  suite "Dummy suite"
          [ claim "sum of two equal integers equals to its multiplication by 2"
          `true`
            (\num -> (num + num) == (2 * num))
          `for`
            int ]

result = quickCheck dummySuite

run = display result >>= \success ->
      exit (if success then 0 else 1)

port responses : Signal Response

port requests : Signal Request
port requests = IO.run responses run
