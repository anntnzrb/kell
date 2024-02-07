module Main (main) where

import Lib qualified (isPalindrome)

main :: IO ()
main = do
  putText "Is 'racecar' a palindrome? -> "
  print $ Lib.isPalindrome "racecar"
