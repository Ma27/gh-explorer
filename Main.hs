{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty
import Data.Text as T
import Data.Text.Lazy as L
import Explore
import Utils

import Database.HDBC
import Database.HDBC.Sqlite3

import Control.Monad.Trans (liftIO)

main = do
  -- simple development database
  conn <- connectSqlite3 "ghex.db"

  -- our beloved webserver
  scotty 3000 $ do
    get "/api/search/:query" $ do
      q <- param "query"
      r <- liftIO $ load q
      json $ vectorResult r

    post "/api/:uuid/preferences" $ do
      u <- strParam "uuid"
      p <- strParam "interests"
      r <- liftIO $ storePreferences u p conn
      json $ if r > -1
             then Left $ Written r $ L.toStrict u
             else Right $ ServiceError "Invalid UUID!" $ L.toStrict u

    get "/api/:uuid/dashboard" $ do
      u <- strParam "uuid"
      r <- liftIO $ generateDashboardQuery u conn
      r' <- liftIO $ load r
      json $ vectorResult r'
