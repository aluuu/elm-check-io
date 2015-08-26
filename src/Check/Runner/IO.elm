module Check.Runner.IO where
{-| IO test runner for elm-check. This module provides functions to
run and visualize tests in the terminal.

# Display Test Results
@docs display

-}

import IO.IO exposing (..)
import IO.Runner exposing (Request, Response)
import IO.Runner as IO

import Check exposing (Evidence(..), SuccessOptions, FailureOptions)

{-| Display test results in the terminal. Additionally, it returns True or False value depending on results of test run.
-}
display : Evidence -> IO Bool
display evidence =
  case evidence of
    Unit unitEvidence ->
      displayUnit unitEvidence
    Multiple name evidences ->
      displaySuite name evidences

displayUnit : Check.UnitEvidence -> IO Bool
displayUnit unitEvidence =
  case unitEvidence of
    Ok options -> successMessage options >>= \_ ->
                  pure True
    Err options -> failureMessage options >>= \_ ->
                   pure False

displaySuite : String -> List Evidence -> IO Bool
displaySuite name evidences =
  putStrLn ("Suite: " ++ name) >>>
  (displaySuite' evidences)

displaySuite' : List Evidence -> IO Bool
displaySuite' evidences =
  case evidences of
    [] -> pure True
    x :: xs ->
         display x >>= \result ->
           displaySuite' xs >>= \result' ->
             pure (result && result')

successMessage : SuccessOptions -> IO ()
successMessage {name, seed, numberOfChecks} =
  putStrLn (name ++ " passed after " ++ (toString numberOfChecks) ++ " checks.")

failureMessage : FailureOptions -> IO ()
failureMessage options =
  let numberOfChecks = (toString options.numberOfChecks) in
  putStrLn (options.name ++ " FAILED after " ++ numberOfChecks ++ " check"++ (if options.numberOfChecks == 1 then "" else "s") ++ "!")
