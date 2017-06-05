{-# LANGUAGE OverloadedStrings #-}
module Explore where

import qualified GitHub.Endpoints.Search as GitHub
import qualified GitHub.Data as GitHub

import Data.Text (Text, pack)
import Data.URLEncoded

load q = do
  repos <- GitHub.searchRepos $ "q=" `mappend` urlEncode q
  return $ case repos of
    Left e -> pack $ show e
    Right r -> "success!"
