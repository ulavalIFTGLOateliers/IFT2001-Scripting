module EndpointApi where

import qualified Data.Map.Strict as M
import Data.Proxy
import Endpoint
import Persistence
import PingEndpoint
import Polysemy
import Polysemy.Error
import Servant
import Types

type EndpointApi =
  "endpoints" :> Get '[JSON] (M.Map Key Endpoint)
    :<|> "endpoints" :> Capture "id" Key :> Get '[JSON] Endpoint
    :<|> "endpoints" :> Capture "id" Key :> "ping" :> Post '[JSON] Endpoint
    :<|> "endpoints" :> ReqBody '[JSON] EndpointCreation :> Post '[JSON] Endpoint

endpointsApi :: Proxy EndpointApi
endpointsApi = Proxy

server :: Members [Persistence, PingEndpoint, Error EndpointError, Embed IO] r => ServerT EndpointApi (Sem r)
server =
  listEndpoints
    :<|> fetchEndpoint
    :<|> pingEndpoint
    :<|> addAndFetch
  where
    addAndFetch endpoint = addEndpoint endpoint >>= fetchEndpoint
