{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleContexts #-}
module Explore where

import qualified GitHub.Endpoints.Search as GitHub
import qualified GitHub.Data as GitHub

import Data.Text (Text, pack)
import Data.Aeson.Types

import GHC.Generics

import Database.HDBC
import Database.HDBC.Sqlite3

data Written = Written { updated :: Integer
                       , uuid :: Text
                       } deriving (Generic, Show)

instance ToJSON GitHub.Repo
instance ToJSON GitHub.SimpleOwner
instance ToJSON GitHub.RepoRef
instance ToJSON GitHub.OwnerType
instance ToJSON Written

load q = do
  repos <- GitHub.searchRepos q
  pure $ case repos of
    Left e -> Nothing
    Right r -> let
                 v = GitHub.searchResultResults r
               in
                 case GitHub.searchResultTotalCount r of
                   0 -> Nothing
                   _ -> Just v

storePreferences u p c = run c
  "INSERT INTO `user_interests` (`uuid`,`interests`) VALUES (?, ?);"
  [toSql u, toSql p]
