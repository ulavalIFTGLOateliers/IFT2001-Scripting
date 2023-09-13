module Types where

import Data.Aeson.Types
import Data.Char (toLower)
import Data.Time.Clock (UTCTime)
import GHC.Int
import Options.Generic (Generic)

lower1 :: String -> String
lower1 (c : cs) = toLower c : cs
lower1 [] = []

dropPrefixAesonOptions :: String -> Options
dropPrefixAesonOptions prefix =
  defaultOptions
    { fieldLabelModifier = lower1 . drop (length prefix)
    }

type EndpointName = String

type EndpointUrl = String

type Key = Int64

newtype EndpointError = EndpointNotFound Types.Key

data EndpointCreation = EndpointCreation
  { endpointCreationName :: EndpointName,
    endpointCreationUrl :: EndpointUrl
  }
  deriving (Eq, Show, Generic)

dropEndpointCreationPrefix :: Options
dropEndpointCreationPrefix = dropPrefixAesonOptions "endpointCreation"

instance FromJSON EndpointCreation where
  parseJSON = genericParseJSON dropEndpointCreationPrefix

data Status
  = Unknown
  | Operational
  | Down
  deriving (Eq, Show, Read, Generic)

statusAesonOption :: Options
statusAesonOption =
  defaultOptions
    { fieldLabelModifier = fmap toLower,
      constructorTagModifier = lower1
    }

instance ToJSON Status where
  toEncoding = genericToEncoding statusAesonOption

data Ping = Ping
  { pingStatus :: Status,
    pingTimestamp :: UTCTime
  }
  deriving (Eq, Show, Generic)

mkPing :: Status -> UTCTime -> Ping
mkPing = Ping

dropPingPrefix :: Options
dropPingPrefix = dropPrefixAesonOptions "ping"

instance ToJSON Ping where
  toEncoding = genericToEncoding dropPingPrefix

data Endpoint = Endpoint
  { endpointName :: EndpointName,
    endpointUrl :: EndpointUrl,
    endpointPings :: [Ping]
  }
  deriving (Eq, Show, Generic)

mkEndpoint :: EndpointName -> EndpointUrl -> [Ping] -> Endpoint
mkEndpoint = Endpoint

dropEndpointPrefix :: Options
dropEndpointPrefix = dropPrefixAesonOptions "endpoint"

instance ToJSON Endpoint where
  toEncoding = genericToEncoding dropEndpointPrefix

fromEndpointCreation :: EndpointCreation -> Endpoint
fromEndpointCreation endpointCreation = Endpoint {endpointName = name, endpointUrl = url, endpointPings = []}
  where
    name = endpointCreationName endpointCreation
    url = endpointCreationUrl endpointCreation

addStatus :: Endpoint -> Ping -> Endpoint
addStatus endpoint status = endpoint {endpointPings = status : endpointPings endpoint}
