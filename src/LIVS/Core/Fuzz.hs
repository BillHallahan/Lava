module LIVS.Core.Fuzz ( fuzzExamplesM
                      , fuzzExampleM
                      , fuzzLitM ) where

import LIVS.Language.Expr
import LIVS.Language.Syntax
import LIVS.Language.Typing
import LIVS.Target.General.LanguageEnv

import Control.Monad.Random

fuzzExamplesM :: MonadRandom m => 
                 LanguageEnv m
              -> FilePath
              -> Int -- ^ How many examples to fuzz
              -> Id -- ^ A function call
              -> m [Example] -- ^ A fuzzed input/output example
fuzzExamplesM le fp n i = do
    load le fp
    mapM (\_ -> fuzzExampleM (call le) i) [1..n]

fuzzExampleM :: MonadRandom m => 
                (Expr -> m Lit) -- ^ Executes and returns the value of the given expression
             -> Id -- ^ A function call
             -> m Example -- ^ A fuzzed input/output example
fuzzExampleM ca i = do
    let ts = argTypes i
    ls <- mapM fuzzLitM ts

    let outE = mkApp (Var i:map Lit ls)
    r <- ca outE 

    return Example { func = i
                   , input = ls
                   , output = r}

fuzzLitM :: MonadRandom m => Type -> m Lit
fuzzLitM t
    | t == intType = return . LInt =<< getRandomR (-100 * 100, 100 * 100)
    | otherwise = error "fuzz: We cannot fuzz values of the given type."