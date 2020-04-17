module Main where

import qualified Issue
import qualified Data.Vector                   as V

main :: IO ()
main = do
  issues <- Issue.loadIssues
  V.forM_ issues $ \x -> putStrLn $ Issue.title x
