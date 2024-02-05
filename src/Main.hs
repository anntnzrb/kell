module Main where

main :: IO ()
main = do
  print $ viaNonEmpty head $ filter odd [2, 4 .. 16 :: Int]
