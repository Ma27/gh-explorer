{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty
import Data.Text as T
import Data.Text.Lazy as L
import Explore

import Data.Maybe
import Data.Vector as V

import Database.HDBC
import Database.HDBC.Sqlite3

import Control.Monad.Trans (liftIO)

main = do
  -- conn and `run conn` are just temporary: we need a real schema
  -- setup here
  conn <- connectSqlite3 "ghex.db"
  run conn "CREATE TABLE IF NOT EXISTS `user_interests` (`uuid` varchar(36) NOT NULL, `interests` text NOT NULL, PRIMARY KEY(`uuid`));" []

  -- our beloved webserver
  scotty 3000 $ do
    get "/api/search/:query" $ do
      q <- param "query"
      r <- liftIO $ load q
      json $ fromMaybe V.empty r

    post "/api/:uuid/preferences" $ do
      u <- param ("uuid" :: L.Text) :: ActionM L.Text
      p <- param ("interests" :: L.Text) :: ActionM L.Text
      r <- liftIO $ storePreferences u p conn
      json $ if validateUUID $ L.unpack u
             then Left $ Written r $ L.toStrict u
             else Right $ ServiceError "Invalid UUID!" $ L.toStrict u
