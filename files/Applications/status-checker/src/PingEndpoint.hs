{-# LANGUAGE TemplateHaskell #-}

module PingEndpoint where

import qualified Control.Monad.Catch as C
import Data.Time
import Network.HTTP.Simple
import Polysemy
import Types

data PingEndpoint m a where
  GetStatus :: Endpoint -> PingEndpoint m Ping

makeSem ''PingEndpoint

getEndpointStatus :: Endpoint -> IO Status
getEndpointStatus endpoint = C.catch pingStatus (\(_ :: HttpException) -> return Down)
  where
    pingStatus :: IO Status
    pingStatus = do
      request <- parseRequest $ "GET " ++ endpointUrl endpoint
      response <- httpLBS request
      return $ (\s -> if s == 200 then Operational else Down) $ getResponseStatusCode response

runPingOnIO :: (Member (Embed IO) r) => Sem (PingEndpoint ': r) a -> Sem r a
runPingOnIO = interpret $ \case
  GetStatus endpoint -> do
    statusType <- embed $ getEndpointStatus endpoint
    timestamp <- embed getCurrentTime
    return $ Ping {pingStatus = statusType, pingTimestamp = timestamp}
