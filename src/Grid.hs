module Grid where

import Control.Monad.State as State
import Control.Monad.Writer as Writer

type Grid a = State.StateT String IO a

runGrid :: Grid a -> IO a
runGrid m = do
                (a,s) <- runStateT m "" 
                return a  

put :: String -> String -> Grid ()
put k v= State.put "Hola" 

get :: String -> Grid String
get k = State.get 

prb = do 
        Grid.put "Hola" ""
        lift $ putStr "Eeeh"
        x <- Grid.get ""
        return x