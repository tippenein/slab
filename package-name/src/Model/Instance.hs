{-# OPTIONS_GHC -fno-warn-orphans #-}

module Model.Instance where

import           ClassyPrelude.Yesod

import qualified Data.Text.Encoding as Encoding
import qualified Data.ByteString.Char8 as B8
import           Data.UUID (UUID)
import qualified Data.UUID as UUID
import           Database.Persist.Sql
import qualified Text.Email.Validate as Email

data Role = Admin | Plebe
  deriving (Show, Read, Eq)

-- allow us to use this sum type in the database layer (Model.hs)
derivePersistField "Role"

instance PersistField UUID where
  toPersistValue u = PersistDbSpecific . B8.pack . UUID.toString $ u
  fromPersistValue (PersistDbSpecific t) =
    case UUID.fromString $ B8.unpack t of
      Just x -> Right x
      Nothing -> Left "Invalid UUID"
  fromPersistValue _ = Left "Not PersistDBSpecific"

instance PersistFieldSql UUID where
  sqlType _ = SqlOther "uuid"

instance PersistField Email.EmailAddress where
  toPersistValue e = PersistDbSpecific . Email.toByteString $ e
  fromPersistValue (PersistDbSpecific t) =
    case (Email.emailAddress =<< Email.canonicalizeEmail t) of
      Just x -> Right x
      Nothing -> Left "Invalid Email"
  fromPersistValue _ = Left "Not PersistDBSpecific"

instance PersistFieldSql Email.EmailAddress where
  sqlType _ = SqlOther "text"

instance FromJSON Email.EmailAddress where
  parseJSON (String e) = case Email.validate (Encoding.encodeUtf8 e) of
    Left _ -> error "invalid email"
    Right r -> pure r
  parseJSON _ = fail "not email"

instance ToJSON Email.EmailAddress where
  toJSON = String . pack . B8.unpack . Email.toByteString
