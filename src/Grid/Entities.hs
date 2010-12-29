{-# LANGUAGE MultiParamTypeClasses #-}
module Grid.Entities where

import Data.Binary
import Data.ByteString

class (Binary e, Binary k) => Entity e k where
     key :: e -> k