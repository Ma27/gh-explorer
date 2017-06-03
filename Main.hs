{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty
import Data.Text (Text, pack)
import Data.Text.Lazy as L
import Explore

import Control.Monad.Trans (liftIO)

main = scotty 3000 $ do
  get "/" $ do
    r <- liftIO load
    text $ fromStrict r
