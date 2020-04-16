{-# LANGUAGE OverloadedStrings #-}

module Issue
  ( readIssues
  , Issue(..)
  )
where

import           Control.Applicative
import qualified Data.ByteString.Lazy          as BL
import           Data.Csv
import qualified Data.Vector                   as V

-- | issueのデータ
data Issue = Issue
  { title :: !String
  , body :: !String
  }

instance FromNamedRecord Issue where
  parseNamedRecord r = Issue <$> r .: "title" <*> r .: "body"

-- | CSVファイルからissueの情報を読み込む
readIssues :: IO (V.Vector Issue)
readIssues = do
  csvData <- BL.readFile "issues.csv"
  case decodeByName csvData of
    Left  err    -> return V.empty
    Right (_, v) -> return v
