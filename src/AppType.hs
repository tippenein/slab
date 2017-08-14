module AppType where

import Import.NoFoundation
import Yesod.Core.Types (Logger)
import Database.Persist.Postgresql (ConnectionPool)

data App = App
    { appSettings    :: AppSettings
    , appStatic      :: Static -- ^ Settings for static file serving.
    , appConnPool    :: ConnectionPool -- ^ Database connection pool.
    , appHttpManager :: Manager
    , appLogger      :: Logger
    }
