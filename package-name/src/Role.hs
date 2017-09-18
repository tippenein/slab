module Role where

import Import.NoFoundation
import Model.User

isAuthenticated :: Role -> Maybe UserId -> DB Bool
isAuthenticated role muid = do
  case muid of
    Nothing -> return False
    Just uid -> do
      roles <- getUserRoles uid
      return $ role `elem` roles
