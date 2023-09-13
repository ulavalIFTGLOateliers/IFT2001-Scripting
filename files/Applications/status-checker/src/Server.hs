{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications #-}

module Server
  ( startServer,
  )
where

import Control.Monad.Except
import CronJobs
import qualified Data.ByteString.Lazy as LBS
import qualified Data.ByteString.Lazy.UTF8 as BLU
import Data.Function ((&))
import Data.Text (pack)
import EndpointApi
import Logging
import Network.Wai.Handler.Warp (Port, defaultSettings, runSettings, setLogger, setPort)
import Network.Wai.Logger (withStdoutLogger)
import Network.Wai.Middleware.Cors
import Persistence (executeMigration, runPersistenceManagingOnIO, runPersistenceOnIO)
import PingEndpoint
import Polysemy
import Polysemy.Error
import Servant.Server
import System.Log.FastLogger
import Types

createApp :: IO Application
createApp = do
  loggerStdout <- fst <$> newFastLogger (LogStdout defaultBufSize)

  _ <- runM $ runPersistenceManagingOnIO executeMigration
  _ <- runM $ runLoggingOnLogger loggerStdout . info $ "Starting server on port " <> pack (show port)

  startCronJobs loggerStdout
  return (serve endpointsApi $ hoistServer endpointsApi (`interpretServer` loggerStdout) server)
  where
    interpretServer sem loggerStdout =
      sem
        & runPingOnIO
        & runPersistenceOnIO
        & runLoggingOnLogger loggerStdout
        & runError @EndpointError
        & runM
        & liftToHandler
    liftToHandler = Handler . ExceptT . fmap handleErrors
    handleErrors (Left (EndpointNotFound endpointId)) = Left err404 {errBody = LBS.concat ["Endpoint ", BLU.fromString $ show endpointId, " does not exist"]}
    handleErrors (Right value) = Right value

port :: Port
port = 8080

startServer :: IO ()
startServer = do
  app <- createApp
  withStdoutLogger $ \appLogger -> do
    let settings = setPort port $ setLogger appLogger defaultSettings
    runSettings settings $ simpleCors app
