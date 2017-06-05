{-# LANGUAGE OverloadedStrings #-}
module Explore where

import qualified GitHub.Endpoints.Search as GitHub
import qualified GitHub.Data as GitHub

import Data.Text (Text, pack)

load = do
  repos <- GitHub.searchRepos "q=topic:haskell"
  return $ case repos of
    Left e -> pack $ show e
    Right r -> "success!"
