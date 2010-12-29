
module Grid where

import Grid.Entities
import Control.Monad.IO.Class
import Data.Maybe
import Data.Binary

class Grid g where
   get :: (Entity e k) => String -> k -> g (Maybe e)
   put :: (Entity e k) => String -> k -> e -> g ()
   getAll :: Binary a => String -> g [a]
   map :: Binary a => String -> (a -> b) -> g [b]
   keys :: Binary a => String -> g [a]