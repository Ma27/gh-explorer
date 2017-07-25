{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Query where

import qualified Data.Text as T

import GHC.Generics
import Data.Maybe
import Text.Regex.Posix

import Data.List.Utils (replace)

data QueryComponent = QueryComponent { name :: T.Text
                                     , content :: [T.Text]
                                     } deriving (Show, Generic, Eq)

parseQ :: String -> [QueryComponent]
parseQ q = resolve q $ match q
  where
    resolve :: String -> [String] -> [QueryComponent]
    resolve q [] = [] :: [QueryComponent]
    resolve q l@(_:_) = map toCmp l ++ [toCmp ("default:" ++ t q l)]
      where
        t :: String -> [String] -> String
        t = foldl st

        st :: String -> String -> String
        st q x = replace x "" q

    toCmp :: String -> QueryComponent
    toCmp s = QueryComponent h $ filter' $ T.splitOn " " $ last s'
      where
        s' = T.splitOn ":" $ T.pack s
        h = if length s' > 1 then head s'
            else T.pack "search"

        filter' :: [T.Text] -> [T.Text]
        filter' = filter (/= "")

    match :: String -> [String]
    match q = getAllTextMatches $ q =~ ("\\w+:(([A-z0-9]+)|\"([A-z0-9 ]+)\")" :: String) :: [String]
