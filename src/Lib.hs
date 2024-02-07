module Lib (
  isPalindrome,
) where

import Data.Char (isPunctuation)
import Data.Text qualified as T

preprocess :: Text -> Text
preprocess = T.filter (not . isPunctuation)

isPalindrome :: Text -> Bool
isPalindrome txt = cleanTxt == T.reverse cleanTxt
  where
    cleanTxt = preprocess txt
