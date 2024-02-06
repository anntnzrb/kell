module Main where

import Lib qualified (someFunc)

main :: IO ()
main = do
  print $ viaNonEmpty head (Lib.someFunc :: [Int])
