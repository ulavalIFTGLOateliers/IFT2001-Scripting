module SampleSpec where

import Data.List
import Test.Hspec
import Test.QuickCheck
import Prelude

newtype SampleData a = SampleData a deriving (Show, Eq)

instance Functor SampleData where
  fmap f (SampleData x) = SampleData $ f x

instance Arbitrary a => Arbitrary (SampleData a) where
  arbitrary = do
    SampleData <$> arbitrary

type ValueType = Integer

type SampleDataType = SampleData ValueType

spec :: Spec
spec = do
  describe "functor instance" $
    do
      it "preserves identity morphism" $
        property $ \(s :: SampleDataType) -> fmap id s == s
      it "preserves composition" $
        property $ \(Fn (f :: ValueType -> ValueType)) (Fn (g :: ValueType -> ValueType)) (s :: SampleDataType) -> fmap (f . g) s == (fmap f . fmap g) s

  describe "simple tests" $
    it "can add stuff" $ 1 + 2 `shouldBe` 3
