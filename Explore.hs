{-# LANGUAGE OverloadedStrings #-}
module Explore where

import qualified GitHub.Endpoints.Search as GitHub
import qualified GitHub.Data as GitHub

import Data.Text (Text, pack)
import Data.List as L
import Data.Vector as V

load q = do
  repos <- GitHub.searchRepos q
  pure $ case repos of
    Left e -> Nothing
    Right r -> Just $ let
                 v = GitHub.searchResultResults r
                 n = GitHub.searchResultTotalCount r
               in
                 case n of
                   0 -> ""
                   _ -> pack $ show $
                        L.intercalate "\n" $
                        V.toList $
                        V.map (resolve . GitHub.repoDescription) v

resolve :: Maybe Text -> String
resolve = maybe "" show
