module Test.PSpec
  ( Spec(), describe, it, itAsync, skip, only, setTimeout
  , pending
  , itIs, itIsNot, itIsNot'

  , skipIf, skipUnless, onlyIf, onlyUnless

  , before, after, beforeEach, afterEach
  , beforeAsync, afterAsync, beforeEachAsync, afterEachAsync

  , before', after', beforeEach', afterEach'
  , beforeAsync', afterAsync', beforeEachAsync', afterEachAsync'
  ) where

import Prelude
import Control.Monad.Eff
import Data.Function
import Data.Maybe
import Data.Array
import qualified Data.String as S

import qualified Test.PSpec.Types as T

type Spec = T.Spec

describe :: forall e. String -> Spec e Unit -> Spec e Unit
describe name sub = T.write (T.Describe name (T.runSpec sub))

it :: forall e. String -> Eff e _ -> Spec e Unit
it name eff = T.write (T.It name (void eff))

itAsync :: forall e. String -> (T.Done -> Eff e _) -> Spec e Unit
itAsync name eff = T.write (T.ItAsync name (\d -> void (eff d)))

setMode :: forall e. T.ExecMode -> Spec e Unit -> Spec e Unit
setMode mode ops = T.write (T.SetMode mode (T.runSpec ops))

skip :: forall e. Spec e Unit -> Spec e Unit
skip = setMode T.skipMode

only :: forall e. Spec e Unit -> Spec e Unit
only = setMode T.onlyMode

skipIf :: forall e. Boolean -> Spec e Unit -> Spec e Unit
skipIf b s = if b then skip s else s

skipUnless :: forall e. Boolean -> Spec e Unit -> Spec e Unit
skipUnless b s = if b then s else skip s

onlyIf :: forall e. Boolean -> Spec e Unit -> Spec e Unit
onlyIf b s = if b then only s else s

onlyUnless :: forall e. Boolean -> Spec e Unit -> Spec e Unit
onlyUnless b s = if b then s else only s

setTimeout :: forall e. Number -> Spec e Unit -> Spec e Unit
setTimeout to sub = T.write (T.SetTimeout to (T.runSpec sub))

pending :: forall e. String -> Spec e Unit
pending name = T.write (T.Pending name)

before'     :: forall e. String -> Eff e _ -> Spec e Unit
before'     name eff = T.write (T.Before     name (void eff))
after'      :: forall e. String -> Eff e _ -> Spec e Unit
after'      name eff = T.write (T.After      name (void eff))
beforeEach' :: forall e. String -> Eff e _ -> Spec e Unit
beforeEach' name eff = T.write (T.BeforeEach name (void eff))
afterEach'  :: forall e. String -> Eff e _ -> Spec e Unit
afterEach'  name eff = T.write (T.AfterEach  name (void eff))

beforeAsync'     :: forall e. String -> (T.Done -> Eff e _) -> Spec e Unit
beforeAsync'     name eff = T.write (T.BeforeAsync     name (\d -> void (eff d)))
afterAsync'      :: forall e. String -> (T.Done -> Eff e _) -> Spec e Unit
afterAsync'      name eff = T.write (T.AfterAsync      name (\d -> void (eff d)))
beforeEachAsync' :: forall e. String -> (T.Done -> Eff e _) -> Spec e Unit
beforeEachAsync' name eff = T.write (T.BeforeEachAsync name (\d -> void (eff d)))
afterEachAsync'  :: forall e. String -> (T.Done -> Eff e _) -> Spec e Unit
afterEachAsync'  name eff = T.write (T.AfterEachAsync  name (\d -> void (eff d)))

before :: forall e. Eff e _ -> Spec e Unit
before = before' ""
after      :: forall e. Eff e _ -> Spec e Unit
after      = after' ""
beforeEach :: forall e. Eff e _ -> Spec e Unit
beforeEach = beforeEach' ""
afterEach  :: forall e. Eff e _ -> Spec e Unit
afterEach  = afterEach' ""

beforeAsync     :: forall e. (T.Done -> Eff e _) -> Spec e Unit
beforeAsync     = beforeAsync' ""
afterAsync      :: forall e. (T.Done -> Eff e _) -> Spec e Unit
afterAsync      = afterAsync' ""
beforeEachAsync :: forall e. (T.Done -> Eff e _) -> Spec e Unit
beforeEachAsync = beforeEachAsync' ""
afterEachAsync  :: forall e. (T.Done -> Eff e _) -> Spec e Unit
afterEachAsync  = afterEachAsync' ""

foreign import itIs :: forall e a. T.Done -> Eff e a

foreign import itIsNotImpl :: forall e a. Fn2 T.Done String (Eff e a)

itIsNot :: forall e a. T.Done -> String -> Eff e a
itIsNot d e = runFn2 itIsNotImpl d e

foreign import itIsNotPrimeImpl :: forall a. Fn2 T.Done String a

itIsNot' :: forall a. T.Done -> String -> a
itIsNot' d e = runFn2 itIsNotPrimeImpl d e
