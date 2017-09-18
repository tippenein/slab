module Handler.Users where

import Import

getUsersR :: Handler Value
getUsersR = do
  uid <- requireAuthId
  posts <- runDB $ selectList [] [] :: Handler [Entity User]

  return $ object ["users" .= users]
