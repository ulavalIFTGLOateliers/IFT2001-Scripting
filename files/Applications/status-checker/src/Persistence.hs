{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE UndecidableInstances #-}

module Persistence
  ( Persistence,
    runPersistenceManagingOnIO,
    runPersistenceOnIO,
    executeMigration,
    getAllEndpoints,
    getEndpoint,
    storeEndpoint,
    updateEndpoint,
  )
where

import Data.List (nub, (\\))
import Data.Text (Text)
import Database.Persist hiding (Key)
import Database.Persist.Sqlite hiding (Key)
import Database.Persist.TH
import Polysemy
import Types

share
  [mkPersist sqlSettings, mkMigrate "migrateAll"]
  [persistLowerCase|
DbEndpoint
    name String
    url String
    deriving Show
DbPing
  status String
  timestamp String
  endpointId DbEndpointId
  deriving Show
|]

pingToDb :: DbEndpointId -> Ping -> DbPing
pingToDb eId p = DbPing (show $ pingStatus p) (show $ pingTimestamp p) eId

pingFromDb :: DbPing -> Ping
pingFromDb p = mkPing (read $ dbPingStatus p) (read $ dbPingTimestamp p)

endpointToDb :: Endpoint -> DbEndpoint
endpointToDb e = DbEndpoint (endpointName e) (endpointUrl e)

endpointFromDb :: DbEndpoint -> [DbPing] -> Endpoint
endpointFromDb e pings = mkEndpoint (dbEndpointName e) (dbEndpointUrl e) (pingFromDb <$> pings)

sqliteDbName :: Text
sqliteDbName = "monitoring.sqlite"

removeIdentity :: Entity a -> a
removeIdentity (Entity _ x) = x

data PersistenceManaging m a where
  ExecuteMigration :: PersistenceManaging m ()

makeSem ''PersistenceManaging

runPersistenceManagingOnIO :: (Member (Embed IO) r) => Sem (PersistenceManaging ': r) a -> Sem r a
runPersistenceManagingOnIO = interpret $ \case
  ExecuteMigration -> embed $ runSqlite sqliteDbName $ runMigration migrateAll

data Persistence m a where
  GetAllEndpoints :: Persistence m [(Key, Endpoint)]
  GetEndpoint :: Key -> Persistence m (Maybe Endpoint)
  StoreEndpoint :: Endpoint -> Persistence m Key
  UpdateEndpoint :: Key -> Endpoint -> Persistence m ()

makeSem ''Persistence

runPersistenceOnIO :: (Member (Embed IO) r) => Sem (Persistence ': r) a -> Sem r a
runPersistenceOnIO =
  interpret $
    \case
      GetAllEndpoints -> embed . runSqlite sqliteDbName $ do
        endpoints :: [Entity DbEndpoint] <- selectList [] []
        pings <- sequenceA $ (\(Entity k _) -> selectList [DbPingEndpointId ==. k] [Desc DbPingTimestamp]) <$> endpoints
        let domainEndpoints = uncurry endpointFromDb <$> zip (removeIdentity <$> endpoints) (fmap removeIdentity <$> pings)
        let keys = (\(Entity k _) -> fromSqlKey k) <$> endpoints
        return $ zip keys domainEndpoints
      GetEndpoint k -> do
        let sqlKey = toSqlKey k
        (maybeEndpoint, pings) <- embed . runSqlite sqliteDbName $ do
          e <- get sqlKey
          ps <- runSqlite sqliteDbName $ selectList [DbPingEndpointId ==. sqlKey] [Desc DbPingTimestamp]
          return (e, ps)
        return $ endpointFromDb <$> maybeEndpoint <*> pure (removeIdentity <$> pings)
      StoreEndpoint endpoint -> embed $ fromSqlKey <$> (runSqlite sqliteDbName . insert . endpointToDb $ endpoint)
      UpdateEndpoint k e -> embed . runSqlite sqliteDbName $ do
        let sqlKey = toSqlKey k
        replace sqlKey (endpointToDb e)
        currentDbPings :: [Entity DbPing] <- selectList [] [Desc DbPingTimestamp]
        let newPings = getNewPings currentDbPings (endpointPings e)
        _ <- sequenceA $ insert . pingToDb sqlKey <$> newPings
        return ()
        where
          getNewPings :: [Entity DbPing] -> [Ping] -> [Ping]
          getNewPings before new = nub $ new \\ (pingFromDb . removeIdentity <$> before)
