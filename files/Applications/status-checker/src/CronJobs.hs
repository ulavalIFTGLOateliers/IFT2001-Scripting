module CronJobs (startCronJobs) where

import Control.Monad.Cont (void)
import Data.Function ((&))
import Endpoint
import Logging
import Persistence
import PingEndpoint (runPingOnIO)
import Polysemy
import Polysemy.Error
import System.Cron
import System.Log.FastLogger
import Types

pingHelper :: FastLogger -> IO ()
pingHelper logger = void $ (pingAllEndpoints >> info "Pinging all endpoints")
  & runPingOnIO
  & runPersistenceOnIO
  & runLoggingOnLogger logger
  & runError @EndpointError
  & runM

startCronJobs :: FastLogger -> IO ()
startCronJobs logger = void $ execSchedule $ addJob (pingHelper logger) "*/1 * * * *"
