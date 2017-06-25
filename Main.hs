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
  -- simple development database
  conn <- connectSqlite3 "ghex.db"

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
      json $ if r > -1
             then Left $ Written r $ L.toStrict u
             else Right $ ServiceError "Invalid UUID!" $ L.toStrict u
