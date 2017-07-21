{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Query where

import qualified Data.Text as T
import Data.Aeson.Types

import GHC.Generics
import Data.Maybe
import Text.Regex

data QueryComponent = QueryComponent { name :: T.Text
                                     , content :: [T.Text]
                                     } deriving (Show, Generic, Eq)

instance ToJSON QueryComponent

parseQ :: String -> [QueryComponent]
parseQ q = resolve $ match q
  where
    resolve :: Maybe (String, String, String, [String]) -> [QueryComponent]
    resolve Nothing = [] :: [QueryComponent]
    resolve (Just (_, _, _, l)) = map toCmp $ filter (/= "") l

    toCmp :: String -> QueryComponent
    toCmp s = QueryComponent "topic" $ T.splitOn " " $ T.pack s

    match :: String -> Maybe (String, String, String, [String])
    match = matchRegexAll (mkRegex "topic:([a-z]+)|\"([a-z ]+)\"")
