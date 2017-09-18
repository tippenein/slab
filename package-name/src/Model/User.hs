{-# OPTIONS_GHC -fno-warn-orphans #-}

{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TemplateHaskell #-}

module Model.User where

import qualified Data.Text.Encoding as Encoding
import Database.Esqueleto
import Import.NoFoundation hiding (on, (==.), Value)
import Text.Email.Validate   as Email
import Model.Instance

getUserRoles :: UserId -> DB [Role]
getUserRoles uid = do
  v <- select $
    from $ \userRole -> do
    where_ (userRole ^. UserRoleUser_id ==. val uid)
    return $ userRole ^. UserRoleRole
  return $ map unValue v

getUsersWithRole :: Role -> DB ([Entity User])
getUsersWithRole role =
  select $
  from $ \(user `InnerJoin` userRole) -> do
  on (user ^. UserId ==. userRole ^. UserRoleUser_id)
  where_ (userRole ^. UserRoleRole ==. val role)
  return user

getUserEntity :: Text -> DB (Maybe (Entity User))
getUserEntity email = fmap listToMaybe $
  select $
  from $ \user -> do
  where_ (user ^. UserIdent ==. val email)
  return user

authenticateUser :: AuthId m ~ UserId => Creds m -> DB (AuthenticationResult m)
authenticateUser Creds{..} = do
  x <- getBy $ UniqueUser $ credsIdent
  case x of
    Just (Entity uid _) -> return $ Authenticated uid
    Nothing -> do
      user_id <- insert User
        { userIdent = credsIdent
        , userName = Nothing
        , userEmail = mkEmail "derp@derp.com"
        }

      _ <- insert $ UserRole user_id Plebe
      return $ Authenticated user_id

mkEmail = hush . Email.validate . Encoding.encodeUtf8
