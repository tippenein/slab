
module Model where

import ClassyPrelude.Yesod
import Model.Instance
import qualified Text.Email.Validate as Email

-- You can define all of your database entities in the entities file.
-- You can find more information on persistent and how to declare entities
-- at:
-- http://www.yesodweb.com/book/persistent/
share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
User json sql=users
  ident Text
  name Text Maybe
  email Email.EmailAddress Maybe
  UniqueUser ident
  UniqueEmail email
  deriving Show Typeable

UserRole sql=user_roles
    user_id UserId
    role Role
    UniqueUserRole user_id role
    deriving Show

Post
  title Text
  content Text

Comment
  post PostId
  content Text
|]

-- some nice material here
-- https://pbrisbin.com/posts/writing_json_apis_with_yesod/

-- { "id": 1, "title": "A title", "content": "The content" }
instance ToJSON (Entity Post) where
    toJSON (Entity pid p) = object
        [ "id"      .= (String $ toPathPiece pid)
        , "title"   .= postTitle p
        , "content" .= postContent p
        ]

instance FromJSON Post where
    parseJSON (Object o) = Post
        <$> o .: "title"
        <*> o .: "content"

    parseJSON _ = mzero

-- { "id": 1, "post_id": 1, "content": "The comment content" }
instance ToJSON (Entity Comment) where
    toJSON (Entity cid c) = object
        [ "id"      .= (String $ toPathPiece cid)
        , "post_id" .= (String $ toPathPiece $ commentPost c)
        , "content" .= commentContent c
        ]

type ControlIO m = (MonadIO m, MonadBaseControl IO m)

type DBM m a = (ControlIO m, MonadThrow m, Monad m) => SqlPersistT m a

type DB a = forall m. DBM m a

type DBVal val =
  ( PersistEntity val
  , PersistEntityBackend val ~ SqlBackend
  , PersistStore (PersistEntityBackend val))
