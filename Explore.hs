{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleContexts #-}
module Explore where

import qualified GitHub.Endpoints.Search as GitHub
import qualified GitHub.Data as GitHub

import Data.Text as T
import Data.Aeson.Types

import GHC.Generics

import Database.HDBC
import Database.HDBC.Sqlite3

import Data.UUID as UUID
import Control.Monad.Trans (liftIO)

import Data.Text.Lazy as L
import System.IO

data Written = Written { updated :: Integer
                       , uuid :: T.Text
                       } deriving (Generic, Show)

data ServiceError = ServiceError { reasonPhrase :: T.Text
                                 , affectedUuid :: T.Text
                                 } deriving (Generic, Show)

instance ToJSON GitHub.Repo
instance ToJSON GitHub.SimpleOwner
instance ToJSON GitHub.RepoRef
instance ToJSON GitHub.OwnerType
instance ToJSON Written
instance ToJSON ServiceError

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

storePreferences u p c =
  if validateUUID $ L.unpack u then
    persist u p c
  else
    pure $ toInteger $ -1
  where
    validateUUID u = case UUID.fromString u of
      Nothing -> False
      Just _ -> True
    persist u p c = do
      n <- liftIO $ run c
             "INSERT INTO `user_interests` (`uuid`,`interests`) VALUES (?, ?);"
             [toSql u, toSql p]
      pure n
