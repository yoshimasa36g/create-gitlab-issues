{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Gitlab where

import qualified Codec.Binary.UTF8.String      as BU
import           Control.Exception.Safe
import           Control.Monad.IO.Class
import qualified Data.ByteString               as B
import qualified Data.ByteString.Lazy          as BL
import           Network.HTTP.Simple
import           Network.HTTP.Conduit
import           Network.URI.Encode
import           Issue                          ( Issue(..) )

apiVersion :: String
apiVersion = "/api/v4"

newIssue :: Issue -> B.ByteString -> IO ()
newIssue issue token = do
  putStrLn $ title issue ++ " を作成します"
  case requestFrom issue of
    Just request -> requestNewIssue request token
    _            -> putStrLn "リクエストを生成できませんでした。"

requestNewIssue :: Request -> B.ByteString -> IO ()
requestNewIssue request token = do
  response <- httpLBS $ withHeaders request
  print $ getResponseStatus response
 where
  withHeaders = setRequestHeaders headers
  headers     = [("Private-Token", token)]

requestFrom :: Issue -> Maybe Request
requestFrom issue =
  parseRequest $ "POST " ++ endPoint issue ++ queryParameters issue

endPoint :: Issue -> String
endPoint issue =
  url issue ++ apiVersion ++ "/projects/" ++ encode (project issue) ++ "/issues"

queryParameters :: Issue -> String
queryParameters issue =
  "?title=" ++ encode (title issue) ++ "&description=" ++ encode (body issue)
