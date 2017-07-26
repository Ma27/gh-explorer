{-# LANGUAGE OverloadedStrings #-}
module Utils where

import Data.Vector as V
import Data.Maybe
import Data.Text as T
import Data.Text.Lazy as L
import Web.Scotty

vectorResult :: Maybe (V.Vector a0) -> V.Vector a0
vectorResult = fromMaybe V.empty

strParam :: L.Text -> ActionM L.Text
strParam n = param(n :: L.Text) :: ActionM L.Text
