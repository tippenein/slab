{-# LANGUAGE CPP #-}
module Import.NoFoundation
    ( module Import
    , hush
    ) where

import ClassyPrelude.Yesod   as Import
import Database.Persist.Sql  as Import
import Model                 as Import
import Settings              as Import
import Data.Aeson            as Import
import Settings.StaticFiles  as Import
import Yesod.Auth            as Import
import Yesod.Core.Types      as Import (loggerSet)
import Yesod.Default.Config2 as Import

hush :: Either a b -> Maybe b
hush (Left _) = Nothing
hush (Right r) = Just r
