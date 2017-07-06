{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty
import Data.Text as T
import Data.Text.Lazy as L
import Explore
import Utils

import Data.Vector as V

import Database.HDBC
import Database.HDBC.Sqlite3

import Data.Maybe

import Control.Monad.Trans (liftIO)
import Control.Monad (when, unless)

import Network.HTTP.Types.Status

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
      o <- strParam "order"
      unless (o `Prelude.elem` ["stars", "date"]) next
      r <- liftIO $ storePreferences u p o conn
      when (r == -1) next
      json $ Written r $ L.toStrict u

    get "/api/:uuid/dashboard" $ do
      u <- strParam "uuid"
      r <- liftIO $ generateDashboardQuery u conn
      when (isNothing r) next
      r' <- liftIO $ load $ fromJust r
      json $ vectorResult r'

    get "/api/:uuid/dashboard" $ status status404
    post "/api/:uuid/preferences" $ do
      u <- strParam "uuid"
      status status400
      json $ ServiceError "Invalid UUID or `order` param!" $ L.toStrict u
