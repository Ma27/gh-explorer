{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Query where

import qualified Data.Text as T

import GHC.Generics
import Data.Maybe
import Text.Regex.Posix

data QueryComponent = QueryComponent { name :: T.Text
                                     , content :: [T.Text]
                                     } deriving (Show, Generic, Eq)

parseQ :: String -> [QueryComponent]
parseQ q = resolve $ match q
  where
    resolve :: [String] -> [QueryComponent]
    resolve [] = [] :: [QueryComponent]
    resolve l@(_:_) = map toCmp l

    toCmp :: String -> QueryComponent
    toCmp s = QueryComponent h $ T.splitOn " " $ last s'
      where
        s' = T.splitOn ":" $ T.pack s
        h = if length s' > 1 then head s'
            else T.pack "search"

    match :: String -> [String]
    match q = getAllTextMatches $ q =~ ("\\w+:(([A-z0-9]+)|\"([A-z0-9 ]+)\")" :: String) :: [String]
