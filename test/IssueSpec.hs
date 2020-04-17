{-# LANGUAGE OverloadedStrings #-}

module IssueSpec
  ( spec
  )
where

import qualified Codec.Binary.UTF8.String      as BU
import qualified Control.Monad                 as M
import qualified Data.ByteString.Lazy          as BL
import qualified Data.Vector                   as V
import qualified System.Directory              as D
import           Test.Hspec

import qualified Issue

createTestFile = do
  file <- Issue.csvFile
  BL.writeFile file "title,body\n"
  M.forM_ [1 .. 3] $ \x -> BL.appendFile file (testData x)
 where
  testData x = BL.pack $ BU.encode $ record x
  record x = "title" ++ (show x) ++ ",body" ++ (show x) ++ "\n"

deleteTestFile = do
  file <- Issue.csvFile
  D.removeFile file

spec :: Spec
spec = do
  before createTestFile $ do
    describe "loadIssues" $ do
      context "CSVファイルが存在しない場合" $ do
        it "空のVectorを返すこと" $ do
          deleteTestFile
          issues <- Issue.loadIssues
          V.null issues `shouldBe` True
      context "CSVファイルが存在する場合" $ do
        it "issue情報のVectorを返すこと" $ do
          issues <- Issue.loadIssues
          issues `shouldBe` expected
 where
  expected = V.generate 3 $ \x -> issue x
  issue x = Issue.Issue { Issue.title = "title" ++ (show $ x + 1)
                        , Issue.body  = "body" ++ (show $ x + 1)
                        }
