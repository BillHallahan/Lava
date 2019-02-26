module Main where

import Test.Tasty

import Language.CallGraph
import Language.Expr
import Language.Naming
import Language.Typing
import LIVS.LIVS

main :: IO ()
main = defaultMain
       =<< return tests

tests :: TestTree
tests =  testGroup "Tests" [ exprTests
                           , namingTests
                           , typingTests
                           , callGraphTests
                           , livsTests ]