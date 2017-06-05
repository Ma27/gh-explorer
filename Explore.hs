{-# LANGUAGE OverloadedStrings #-}
module Explore where

import qualified GitHub.Endpoints.Search as GitHub
import qualified GitHub.Data as GitHub

import Data.Text (Text, pack)
import Data.Vector as V

load q = do
  repos <- GitHub.searchRepos $ "q=" `mappend` q
  return $ case repos of
    Left e -> pack $ show e
    Right r -> let
                 v = GitHub.searchResultResults r
                 n = GitHub.searchResultTotalCount r
               in
                 case n of
                   0 -> ""
                   _ -> resolve $ GitHub.repoDescription $ V.head v

-- TODO just a shortcut for a string-based getOrElse. Needs refactoring later...
resolve :: Maybe Text -> Text
resolve s = pack $ maybe "" show s
