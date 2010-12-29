{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE NoMonomorphismRestriction #-}

module Grid.Impl.Local where

import Grid
import Grid.Entities
import Data.Map as M
import Control.Monad.State.Lazy as S
import Data.Maybe 
import Data.ByteString.Lazy.Internal
import Data.Binary

instance Monad m => Grid (S.StateT (M.Map String (M.Map ByteString ByteString)) m) where 
    get storeName k = do 
                     im <- getStore storeName
                     return (maybe Nothing (\x -> Just (decode x)) (M.lookup (encode k) im))
    put storeName k e = do
                     im <- getStore storeName
                     putStore storeName $ insert (encode k) (encode e) im
    getAll storeName = do 
                        im <- getStore storeName
                        return $ Prelude.map decode (M.elems im)

    keys storeName = do
                        im <- getStore storeName
                        return $ Prelude.map decode (M.keys im)
    
    map storeName f = do
                        im <- getStore storeName
                        return $ Prelude.map f $ Prelude.map decode (M.keys im)

putStore storeName newMap = do
                              internalMaps <- S.get
                              S.put $ insert storeName newMap internalMaps
getStore storeName = do
                      internalMaps <- S.get
                      return (maybe M.empty id (M.lookup storeName internalMaps))

runLocal runnable = do 
                       (a,s) <- runStateT runnable (M.empty::(M.Map String (M.Map ByteString ByteString)))
                       return a