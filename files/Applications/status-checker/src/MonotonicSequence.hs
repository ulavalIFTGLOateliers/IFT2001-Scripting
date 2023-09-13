{-# LANGUAGE TemplateHaskell #-}

module MonotonicSequence where

import Polysemy
import Polysemy.AtomicState

data MonotonicSequence v m a where
  Next :: MonotonicSequence v m v

makeSem ''MonotonicSequence

runMonotonicSequenceOnState :: (Member (AtomicState v) r, Num v) => Sem (MonotonicSequence v ': r) a -> Sem r a
runMonotonicSequenceOnState = interpret $ \case
  Next -> atomicModify (+ 1) >> atomicGet
