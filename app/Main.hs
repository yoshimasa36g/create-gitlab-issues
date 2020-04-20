{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Codec.Binary.UTF8.String      as BU
import qualified Data.ByteString               as B
import qualified Data.Vector                   as V
import           System.Environment             ( lookupEnv )
import qualified Gitlab
import qualified Issue

main :: IO ()
main = do
  maybeToken <- accessToken
  case maybeToken of
    Just token -> do
      issues <- Issue.loadIssues
      V.forM_ issues $ \issue -> Gitlab.newIssue issue token
    _ -> putStrLn "環境変数 ACCESS_TOKEN を設定してください。"

accessToken :: IO (Maybe B.ByteString)
accessToken = do
  env <- lookupEnv "ACCESS_TOKEN"
  case env of
    Just token -> return $ Just (B.pack $ BU.encode token)
    _          -> return Nothing
