{-# LANGUAGE OverloadedStrings #-}
module Explore where

import qualified GitHub.Endpoints.Users.Followers as GitHub

import Data.Monoid ((<>))
import Data.Text (Text, pack)

load = do
  possibleUsers <- GitHub.usersFollowing "ma27"
  return $ either (("Error: " <>) . pack . show)
    (foldMap ((<> "\n") . formatUser))
    possibleUsers

formatUser :: GitHub.SimpleUser -> Data.Text.Text
formatUser = GitHub.untagName . GitHub.simpleUserLogin
