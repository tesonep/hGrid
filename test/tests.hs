{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NoMonomorphismRestriction #-}

import Grid
import Grid.Entities
import Grid.Impl.Local
import Control.Monad.State

import Data.Binary as B

data Persona = Persona {nombre::String,apellido::String,dni::Integer} deriving (Show,Eq)

data Animal = Animal {n::String,a::String} deriving (Show,Eq)

data PersonaKey = PersonaKey Integer deriving (Show,Eq)

instance Binary Animal where
    get = do n <- B.get
             a <- B.get
             return (Animal {n=n,a=a})
    put p= do B.put (n p)
              B.put (a p)

instance Binary Persona where
    get = do n <- B.get;
             a <- B.get;
             d <- B.get;
             return (Persona {nombre=n,apellido=a,dni=d})
   
    put p = do B.put (nombre p);
               B.put (apellido p);
               B.put (dni p)


instance Binary PersonaKey where
    get = do d <- B.get; return (PersonaKey d)
    put (PersonaKey k) = do B.put k


instance Entity Persona PersonaKey where
    key p = PersonaKey (dni p)

instance Entity Animal PersonaKey where
    key p = undefined

prb = do 
        Grid.put "anotherStore" (PersonaKey 12345) (Animal {n="Pablo",a="T"})
        Grid.put "anStore" (PersonaKey 12345) (Persona {nombre="Pablo",apellido="T",dni=12345})
        Grid.put "anStore" (PersonaKey 12346) (Persona {nombre="Pablo'",apellido="T",dni=12346})
        Grid.put "anStore" (PersonaKey 12347) (Persona {nombre="Pablo''",apellido="T",dni=12347})
        x <- Grid.getAll "anStore"
        lift $ putStrLn $ show $(x :: [Persona])
        y <- Grid.getAll "anotherStore"
        lift $ putStrLn $ show $(y :: [Animal])
        return ()