{-# LANGUAGE TemplateHaskell #-}

module Logging where

import Data.Text
import Polysemy
import System.Log.FastLogger

data Severity
  = Trace
  | Debug
  | Info
  | Warning
  | Error
  | Critical

instance ToLogStr Severity where
  toLogStr Trace = "[TRACE]"
  toLogStr Debug = "[DEBUG]"
  toLogStr Info = "[INFO]"
  toLogStr Warning = "[WARN]"
  toLogStr Error = "[ERROR]"
  toLogStr Critical = "[CRITICAL]"

data LogMessage = LogMessage
  { logSeverity :: !Severity,
    logMessage :: !Text
  }

mkLogMessage :: Severity -> Text -> LogMessage
mkLogMessage logSeverity logMessage = LogMessage {logSeverity, logMessage}

instance ToLogStr LogMessage where
  toLogStr LogMessage {logSeverity = sev, logMessage = msg} =
    toLogStr sev <> toLogStr (" " :: Text) <> toLogStr msg <> toLogStr ("\n" :: Text)

data Logging m a where
  LogMsg :: LogMessage -> Logging m ()

makeSem ''Logging

runLoggingOnLogger :: Member (Embed IO) r => FastLogger -> Sem (Logging ': r) a -> Sem r a
runLoggingOnLogger logger = interpret $ \case
  LogMsg msg -> embed . logger . toLogStr $ msg

trace :: Member Logging r => Text -> Sem r ()
trace msg = logMsg $ mkLogMessage Trace msg

debug :: Member Logging r => Text -> Sem r ()
debug msg = logMsg $ mkLogMessage Debug msg

info :: Member Logging r => Text -> Sem r ()
info msg = logMsg $ mkLogMessage Info msg

warning :: Member Logging r => Text -> Sem r ()
warning msg = logMsg $ mkLogMessage Warning msg

error :: Member Logging r => Text -> Sem r ()
error msg = logMsg $ mkLogMessage Error msg

critical :: Member Logging r => Text -> Sem r ()
critical msg = logMsg $ mkLogMessage Critical msg
