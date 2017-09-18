module Role where

import           Import.NoFoundation hiding (on, (==.), Value)
import           Model.Instance
import           Model.User

isAuthenticated :: Role -> Maybe UserId -> DB Bool
isAuthenticated role muid = do
  case muid of
    Nothing -> return False
    Just uid -> do
      roles <- getUserRoles uid
      return $ role `elem` roles

isAdmin :: Maybe UserId -> DB Bool
isAdmin = isAuthenticated Admin

canListUsers :: Maybe UserId -> DB Bool
canListUsers (Just uid) = isAdmin (Just uid)
canListUsers Nothing = return False
