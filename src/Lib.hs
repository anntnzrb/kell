module Lib (
  someFunc,
) where

someFunc :: (Integral a) => [a]
someFunc = filter odd [2, 4 .. 16]
