module Handler.Users where

import Import

getUsersR :: Handler Value
getUsersR = do
  uid <- requireAuthId
  users <- runDB $ selectList [] [] :: Handler [Entity User]

  return $ object ["users" .= users]
