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
    Left e -> pack $ show e
    Right r -> let
                 v = GitHub.searchResultResults r
                 n = GitHub.searchResultTotalCount r
               in
                 case n of
                   0 -> ""
                   _ -> pack $ show $
                        L.intercalate "\n" $
                        V.toList $
                        V.map (\x -> resolve $ GitHub.repoDescription x) v

resolve :: Maybe Text -> [Char]
resolve s = maybe "" show s
