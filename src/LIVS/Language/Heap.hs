module LIVS.Language.Heap ( Heap
                          , HeapObj (..)
                          , empty
                          , fromList
                          , insertDef
                          , insertPrimitive
                          , lookup
                          , map
                          , mapDefs
                          , map'
                          , mapWithKey
                          , mapWithKeyDefs
                          , mapWithKey'
                          , mapWithKeyDefs'
                          , filter
                          , filterWithKey
                          , keys
                          , elems
                          , toHashMap
                          , toList

                          , fromDef
                          , catDefs
                          , isDef
                          , isPrimitive
                          , isDefObj
                          , isPrimitiveObj ) where

import LIVS.Language.Syntax
import LIVS.Language.Typing

import qualified Data.HashMap.Lazy as M
import Data.Maybe
import Prelude hiding (map, filter, lookup)
import qualified Prelude as P

newtype Heap = Heap { unHeap :: M.HashMap Name HeapObj } deriving (Show, Read)

-- | A HeapObj is either a concrete function defintion, represented as an Expr
-- , or a primitive SMT/SyGuS operation, which only has a type.
data HeapObj = Def Expr
             | Primitive Type deriving (Eq, Show, Read)

instance Typed HeapObj where
  typeOf (Def e) = typeOf e
  typeOf (Primitive t) = t

empty :: Heap
empty = Heap M.empty

fromList :: [(Name, HeapObj)] -> Heap
fromList = Heap . M.fromList

insertDef :: Name -> Expr -> Heap -> Heap
insertDef n e = Heap . M.insert n (Def e) . unHeap

insertPrimitive :: Name -> Type -> Heap -> Heap
insertPrimitive n t = Heap . M.insert n (Primitive t) . unHeap

lookup :: Name -> Heap -> Maybe HeapObj
lookup n = M.lookup n . unHeap

map :: (HeapObj -> HeapObj) -> Heap -> Heap
map f = Heap . M.map f . unHeap

mapDefs :: (Expr -> Expr) -> Heap -> Heap
mapDefs f = map f'
    where
        f' (Def e) = Def $ f e
        f' p = p
  
map' :: (HeapObj -> v) -> Heap -> M.HashMap Name v
map' f = M.map f . unHeap

mapWithKey :: (Name -> HeapObj -> HeapObj) -> Heap -> Heap
mapWithKey f = Heap . M.mapWithKey f . unHeap

mapWithKeyDefs :: (Name -> Expr -> Expr) -> Heap -> Heap
mapWithKeyDefs f = mapWithKey f'
    where
        f' n (Def e) = Def $ f n e
        f' _ p = p

mapWithKey' :: (Name -> HeapObj -> v) -> Heap -> M.HashMap Name v
mapWithKey' f = M.mapWithKey f . unHeap

mapWithKeyDefs' :: (Name -> Expr -> v) -> Heap -> M.HashMap Name v
mapWithKeyDefs' f = M.mapMaybeWithKey f' . unHeap
    where
        f' n (Def e) = Just $ f n e
        f' _ _ = Nothing

filter :: (HeapObj -> Bool) -> Heap -> Heap
filter p = Heap . M.filter p . unHeap 

filterWithKey :: (Name -> HeapObj -> Bool) -> Heap -> Heap
filterWithKey p = Heap . M.filterWithKey p . unHeap

keys :: Heap -> [Name]
keys = M.keys . unHeap

elems :: Heap -> [HeapObj]
elems = M.elems . unHeap

toHashMap :: Heap -> M.HashMap Name HeapObj
toHashMap = unHeap

toList :: Heap -> [(Name, HeapObj)]
toList = M.toList . unHeap

fromDef :: HeapObj -> Maybe Expr
fromDef (Def e) = Just e
fromDef _ = Nothing

catDefs :: [HeapObj] -> [Expr]
catDefs = catMaybes . P.map fromDef

isDef :: Name -> Heap -> Bool
isDef n h = maybe False isDefObj $ lookup n h

isPrimitive :: Name -> Heap -> Bool
isPrimitive n h = maybe False isPrimitiveObj $ lookup n h

isDefObj :: HeapObj -> Bool
isDefObj (Def _) = True
isDefObj _ = False

isPrimitiveObj :: HeapObj -> Bool
isPrimitiveObj (Primitive _) = True
isPrimitiveObj _ = False