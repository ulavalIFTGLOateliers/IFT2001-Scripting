{-# LANGUAGE OverloadedStrings #-}

module Endpoint where

import Control.Error.Safe (justErr)
import Data.Functor ((<&>))
import qualified Data.Map.Strict as M
import Persistence
import PingEndpoint
import Polysemy
import Polysemy.Error
import Types

addEndpoint :: Member Persistence r => EndpointCreation -> Sem r Types.Key
addEndpoint endpoint = do
  storeEndpoint $ fromEndpointCreation endpoint

listEndpoints :: Member Persistence r => Sem r (M.Map Types.Key Endpoint)
listEndpoints = fmap M.fromList getAllEndpoints

fetchEndpoint :: Members [Persistence, Error EndpointError] r => Types.Key -> Sem r Endpoint
fetchEndpoint endpointId =
  getEndpoint endpointId >>= \case
    Just endpoint -> pure endpoint
    Nothing -> throw $ EndpointNotFound endpointId

pingEndpoint :: Members [Persistence, PingEndpoint, Error EndpointError, Embed IO] r => Types.Key -> Sem r Endpoint
pingEndpoint key = do
  endpointErr <- getEndpoint key <&> justErr (EndpointNotFound key)
  endpoint <- either throw return endpointErr

  newStatus <- getStatus endpoint
  let newEndpoint = addStatus endpoint newStatus

  updateEndpoint key newEndpoint
  return newEndpoint

pingAllEndpoints :: Members [Persistence, PingEndpoint, Error EndpointError, Embed IO] r => Sem r ()
pingAllEndpoints = do
  endpoints <- M.keys <$> listEndpoints
  mapM_ pingEndpoint endpoints
