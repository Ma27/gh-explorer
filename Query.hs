{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Query where

import qualified Data.Text as T
import Data.Aeson.Types

import GHC.Generics

data QueryComponent = QueryComponent { name :: T.Text
                                     , content :: [T.Text]
                                     } deriving (Show, Generic, Eq)

instance ToJSON QueryComponent

parseQ :: String -> [QueryComponent]
parseQ q = [QueryComponent "default" $ T.splitOn " " $ T.pack q]
