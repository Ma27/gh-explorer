{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty
import Data.Text as T
import Data.Text.Lazy as L
import Explore

import Data.Maybe
import Data.Vector as V

import Control.Monad.Trans (liftIO)

main = scotty 3000 $
  get "/api/search/:query" $ do
    q <- param "query"
    r <- liftIO $ load q
    json $ fromMaybe V.empty r
