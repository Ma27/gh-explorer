{-# LANGUAGE OverloadedStrings #-}
import Web.Scotty

import Data.Text         (Text, pack)
import Data.Text.IO as T (putStrLn)
import Data.Monoid       ((<>))
import Data.Text.Lazy as L

import qualified GitHub.Endpoints.Users.Followers as GitHub

import Control.Monad.Trans (liftIO)

main = scotty 3000 $ do
  get "/" $ do
    r <- liftIO load
    text $ fromStrict r

load = do
  possibleUsers <- GitHub.usersFollowing "ma27"
  return $ either (("Error: " <>) . Data.Text.pack . show)
    (foldMap ((<> "\n") . formatUser))
    possibleUsers

formatUser :: GitHub.SimpleUser -> Data.Text.Text
formatUser = GitHub.untagName . GitHub.simpleUserLogin
