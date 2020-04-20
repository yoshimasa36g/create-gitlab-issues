{-# LANGUAGE OverloadedStrings #-}

module Issue
  ( loadIssues
  , Issue(..)
  , csvFile
  )
where

import           Control.Monad.Catch
import qualified Data.ByteString.Lazy          as BL
import           Data.Csv
import qualified Data.Vector                   as V
import           System.Environment             ( lookupEnv )

-- | issueのデータ
data Issue = Issue
  { url :: !String
  , project :: !String
  , title :: !String
  , body :: !String
  } deriving (Eq, Show)

instance FromNamedRecord Issue where
  parseNamedRecord r = Issue
    <$> r .: "url"
    <*> r .: "project"
    <*> r .: "title"
    <*> r .: "body"

-- | CSVファイルからissueの情報を読み込む
loadIssues :: IO (V.Vector Issue)
loadIssues = do
  file    <- csvFile
  csvData <- (BL.readFile file) `catch` emptyCsv
  case decodeByName csvData of
    Left  err    -> return V.empty
    Right (_, v) -> return v
 where
  emptyCsv :: SomeException -> IO BL.ByteString
  emptyCsv _ = return ""

-- | CSVファイル名
csvFile :: IO String
csvFile = do
  env <- lookupEnv "STACK_ENV"
  case env of
    Just "test" -> return "./issues.test.csv"
    _           -> return "./issues.csv"
