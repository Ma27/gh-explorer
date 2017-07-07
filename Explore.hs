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
import qualified Data.Vector as V
import Data.Maybe

import Data.Time.Clock
import Data.Time.Calendar

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

storePreferences u p f c = do
  un <- liftIO $ countUUIDs u c
  if isUUID c (L.unpack u) && (toInteger un < toInteger 1)
    then persist u p f c
    else pure $ toInteger $ -1
  where
    isUUID c u = case UUID.fromString u of
      Nothing -> False
      Just _ -> True
    countUUIDs u c = do
      q <- prepare c "SELECT `uuid` FROM `user_interests` WHERE `uuid` = ?"
      execute q [toSql u]
      r <- liftIO $ fetchAllRows q
      pure $ Prelude.length r
    persist u p f c = do
      n <- liftIO $ run c
             "INSERT INTO `user_interests` (`uuid`,`interests`,`filter`) VALUES (?, ?, ?);"
             [toSql u, toSql p, toSql f]
      pure n

generateDashboardQuery u c = do
  r <- liftIO $ prefs u c
  d <- date'
  pure $ case r of
    Nothing -> Nothing
    Just (p, f) -> Just $ prefs2query d f p
  where
    prefs2query d f p = T.pack $ "topic:\""
      ++ T.unpack (T.intercalate " || " $ T.splitOn " " p)
      ++ "\" "
      ++ if f == "date" then "created:>=" ++ d
         else "stars:>5000"

    prefs u c = do
      q <- prepare c "SELECT `interests`, `filter` FROM `user_interests` WHERE `uuid` = ?"
      execute q [toSql u]
      r <- liftIO $ fetchAllRows q
      pure $ let
               h = head' r
             in case Prelude.length h of
               0 -> Nothing
               _ -> Just (
                          fromSql $ Prelude.head h :: T.Text,
                          fromSql $ Prelude.last h :: T.Text
                         )

    head' [] = []
    head' (x:_) = x

    date' = do
      d <- date (toGregorian . utctDay)
      let (y, _, _) = d
      pure $ show y

persistStat q c = do
  t' <- date (showGregorian . utctDay)
  run c
    "INSERT INTO `stats` (`query`,`time`) VALUES (?, ?)"
    [toSql q, toSql t']
  pure True

stats c = do
  r <- liftIO $ loadStats c
  let a = Prelude.map (Prelude.map fromSql) r :: [[String]]
  pure a
  where
    loadStats c = do
      q <- prepare c "SELECT `query`, `time` FROM `stats`;"
      execute q []
      r <- liftIO $ fetchAllRows q
      pure $ Prelude.map (Prelude.map fromSql) r

date x = fmap x getCurrentTime
