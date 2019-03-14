module Interpreter.Interpreter (interpreterTests) where

import LIVS.Interpreter.Interpreter
import qualified LIVS.Language.Heap as H
import LIVS.Language.Naming
import LIVS.Language.Syntax
import LIVS.Language.Typing
import LIVS.Language.Monad.Heap
import LIVS.Target.General.LanguageEnv

import Helpers.Interpreter
import Helpers.Language

import Data.Functor.Identity
import Data.HashSet as HS

import Test.Tasty
import Test.Tasty.HUnit

interpreterTests :: TestTree
interpreterTests = testGroup "Interpreter" [ run1
                                           , runCollectingExamples1
                                           , runCollectingExamples2
                                           , runCollectingExamples3 ]

run1 :: TestTree
run1 = testCase "Run Test 1"
    $ assertBool "Correct run1" 
            (runWithIdentity (langEnv heapAbs) 100 heapAbs (mkNameGen []) e == Lit (LInt 4))
    where
        abs2 = Var (Id (Name "abs2" Nothing) (TyFun intType intType))
        e = App abs2 (Lit (LInt 4))

runCollectingExamples1 :: TestTree
runCollectingExamples1 = testCase "runCollectingExamples Test 1"
    $ assertBool "Correct examples in runCollectingExamples1" 
            (let
                exs = HS.fromList (snd $ runCollectingExamplesWithIdentity (langEnv heapAbs) 100 heapAbs (mkNameGen []) e)
            in
            (Suspect abs2Ex) `HS.member` exs && (Suspect iteEx) `HS.member` exs
            )
    where
        abs3 = Var (Id (Name "abs3" Nothing) (TyFun intType intType))
        e = App abs3 (Lit (LInt (-4)))

        abs2Ex = Example { func = Id (Name "abs2" Nothing) (TyFun intType intType)
                        , input = [ LitVal (LInt (-4)) ]
                        , output = LitVal (LInt 4) }

        iteEx = Example { func = iteId
                        , input = [ DataVal (DC (Name "true" Nothing) (TyCon (Name "Bool" Nothing) TYPE))
                                  , LitVal (LInt 4), LitVal (LInt (-4)) ]
                        , output = LitVal (LInt 4) }

runCollectingExamples2 :: TestTree
runCollectingExamples2 = testCase "runCollectingExamples Test 2"
    $ assertBool "Correct number of examples in runCollectingExamples2" 
            (let
                exs = snd $ runCollectingExamplesWithIdentity (langEnv heapAbs) 100 heapAbs (mkNameGen []) e
            in
            length exs == 5
            )
    where
        abs3 = Var (Id (Name "abs3" Nothing) (TyFun intType intType))
        e = App abs3 (Lit (LInt (-4)))

runCollectingExamples3 :: TestTree
runCollectingExamples3 = testCase "runCollectingExamples Test 3"
    $ assertBool "Correct examples in runCollectingExamples3"
            (let
                exs = HS.fromList (snd $ runCollectingExamplesWithIdentity (langEnv h) 100 h (mkNameGen []) e)
            in
            (Suspect idEx) `HS.member` exs
            )
    where
        h = H.fromList 
            [ ( Name "id" Nothing
              , H.Def
                    (Lam
                        (Id (Name "x1" Nothing) intType)
                        (Var (Id (Name "x1" Nothing) intType))
                    )
              )
            , ( Name "f" Nothing
              , H.Def
                    (Lam
                        (Id (Name "x1" Nothing) intType)
                        (App
                            (Var idF)
                            (Var (Id (Name "x1" Nothing) intType))
                        )
                    )
              )
            , ( Name "ite" Nothing
              , H.Primitive (TyFun (TyCon (Name "Bool" Nothing) TYPE) (TyFun intType (TyFun intType intType)))
              )
            , ( Name ">=" Nothing 
              , H.Primitive (TyFun intType (TyFun intType (TyCon (Name "Bool" Nothing) TYPE)))
              )
            , ( Name "-" Nothing 
              , H.Primitive (TyFun intType (TyFun intType intType))
              )
            ]

        f = Id (Name "f" Nothing) (TyFun intType intType)
        idF = Id (Name "id" Nothing) (TyFun intType intType)

        e = App (Var f) (Lit (LInt (-3)))

        idEx = Example { func = Id (Name "id" Nothing) (TyFun intType intType)
                       , input = [ LitVal (LInt (-3)) ]
                       , output = LitVal (LInt (-3)) }

runWithIdentity :: LanguageEnv Identity -> Int -> H.Heap -> NameGen -> Expr -> Expr
runWithIdentity le n h ng e = runIdentity (run le n h ng e)

runCollectingExamplesWithIdentity :: LanguageEnv Identity -> Int -> H.Heap -> NameGen -> Expr ->  (Expr, [SuspectExample])
runCollectingExamplesWithIdentity le n h ng e = runIdentity (runCollectingExamples le n h ng e)