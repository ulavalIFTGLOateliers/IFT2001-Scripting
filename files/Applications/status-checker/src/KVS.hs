{-# LANGUAGE TemplateHaskell #-}

module KVS where

import qualified Data.Map.Strict as M
import Polysemy
import Polysemy.AtomicState

data KVS k v m a where
  ListAllKvs :: KVS k v m [(k, v)]
  GetKvs :: k -> KVS k v m (Maybe v)
  InsertKvs :: k -> v -> KVS k v m ()
  DeleteKvs :: k -> KVS k v m ()

makeSem ''KVS

runKvsOnMapState :: (Member (AtomicState (M.Map k v)) r, Ord k) => Sem (KVS k v ': r) a -> Sem r a
runKvsOnMapState = interpret $ \case
  ListAllKvs -> fmap M.toList atomicGet
  GetKvs k -> fmap (M.lookup k) atomicGet
  InsertKvs k v -> atomicModify $ M.insert k v
  DeleteKvs k -> atomicModify $ M.delete k
