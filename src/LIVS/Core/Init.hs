module LIVS.Core.Init where

import LIVS.Core.Fuzz
import LIVS.Core.GenConsts
import LIVS.Core.LIVSSynth

import LIVS.Config.Config

import LIVS.Language.CallGraph
import qualified LIVS.Language.Heap as H
import LIVS.Language.Naming
import LIVS.Language.Syntax
import qualified LIVS.Language.TypeEnv as T
import LIVS.Language.Typing
import LIVS.Language.Monad.Naming

import LIVS.Target.General.LanguageEnv
import LIVS.Target.JavaScript.Interface
import LIVS.Target.JavaScript.JSIdentifier

import LIVS.UI.Parse

import Control.Monad.IO.Class
import Control.Monad.Random.Class

import qualified Data.HashMap.Lazy as HM
import qualified Data.HashSet as S
import Data.List
import Data.Maybe

import System.Console.CmdArgs
import System.Random

synth :: (MonadRandom m, MonadIO m) => LIVSConfigCL -> LanguageEnv m b -> m String
synth config@(LIVSConfig { code_file = fp }) lenv = do
    synth_ex <- examplesFromFile jsJSONToVal fp

    -- liftIO $ print synth_ex

    (ids, b) <- extract lenv fp

    let heap = H.fromList [ (Name SMT "=" Nothing, H.Primitive $ TyFun intType (TyFun intType boolType))
                          , (Name SMT "=" (Just 1), H.Primitive $ TyFun stringType (TyFun stringType boolType))
                          , (Name SMT "=" (Just 2), H.Primitive $ TyFun boolType (TyFun boolType boolType))
                          , (Name SMT "not" Nothing, H.Primitive $ TyFun boolType boolType)
                          , (Name SMT "and" Nothing, H.Primitive $ TyFun boolType (TyFun boolType boolType))
                          , (Name SMT "or" Nothing, H.Primitive $ TyFun boolType (TyFun boolType boolType))
                          , (Name SMT ">" Nothing, H.Primitive $ TyFun intType (TyFun intType boolType))
                          , (Name SMT "+" Nothing, H.Primitive $ TyFun intType (TyFun intType intType))
                          , (Name SMT "-" Nothing, H.Primitive $ TyFun intType (TyFun intType intType))
                          , (Name SMT "*" Nothing, H.Primitive $ TyFun intType (TyFun intType intType))
                          , (Name SMT "ite" Nothing, H.Primitive $ TyFun boolType (TyFun intType (TyFun intType intType)))
                          , (Name SMT "ite" (Just 1), H.Primitive $ TyFun boolType (TyFun stringType (TyFun stringType stringType)))
                          , (Name SMT "ite" (Just 2), H.Primitive $ TyFun boolType (TyFun boolType (TyFun boolType boolType)))
                          , (Name SMT "ite" (Just 3), H.Primitive $ TyFun boolType (TyFun jsIdentType (TyFun jsIdentType jsIdentType)))
                          , (Name SMT "str.substr" Nothing, H.Primitive $ TyFun stringType (TyFun intType (TyFun intType stringType)))
                          , (Name SMT "str.replace" Nothing, H.Primitive $ TyFun stringType (TyFun stringType (TyFun stringType stringType)))
                          , (Name SMT "str.replaceall" Nothing, H.Primitive $ TyFun stringType (TyFun stringType (TyFun stringType stringType)))
                          , (Name SMT "str.len" Nothing, H.Primitive $ TyFun stringType intType)
                          , (Name SMT "str.indexof" Nothing, H.Primitive $ TyFun stringType (TyFun stringType (TyFun intType intType)))
                          , (Name SMT "str.++" Nothing, H.Primitive $ TyFun stringType (TyFun stringType stringType))
                          , (Name SMT "int.to.str" Nothing, H.Primitive $ TyFun intType stringType)
                          -- , (Name SMT "\"true\"" Nothing, H.Primitive $ stringType)
                          -- , (Name SMT "\"false\"" Nothing, H.Primitive $ stringType)
                          ]

    let config' = toLIVSConfigNames heap config

    let tenv = jsTypeEnv

    -- We want type constructors, selectors and testers to be available in the
    -- SyGuS grammar, so we add them to the heap and the list of grammatical
    -- elements to always be included
    let config'' = addCoreFuncs config'
                    (T.constructorNames tenv ++ T.selectorNames tenv ++ T.testerNames tenv)
        heap' = T.mergeConstructors tenv heap
        heap'' = T.mergeSelectorsAndTesters tenv heap'

    let all_calls = concatMap (calls . snd) ids
        all_uncovered_calls = all_calls \\ map fst ids
        all_uc_fd = map (\un -> (un, mempty)) all_uncovered_calls

        core_func_ids = map (\n -> Id n (typeOf $ fromJust $ H.lookup n heap'')) $ core_funcs config''
        ids' = map (\(i, fi) -> (i, addCalls fi core_func_ids) ) $ all_uc_fd ++ ids
        cg = createCallGraph (idsAndCalls ids')

    let cs = concatMap (consts . snd) ids
        cs' = genConsts cs
        -- fuzz_with = genFuzzConsts $ cs ++ concatMap exampleVals synth_ex
        fuzz_with = cs ++ concatMap exampleVals synth_ex
        fuzz_with' = fuzz_with ++ genConsts fuzz_with
        fuzz_with'' = expandVals fuzz_with' tenv
        -- fuzz_with' = expandVals fuzz_with tenv
        ics = genIntsConsts cs

        cnst = fromListConstants $ map (\(i, fi) -> (idName i, genConsts $ consts fi)) ids

    let r = toRational (1 :: Double)
        w = HM.fromList [(jsIntDC, r), (jsStringDC, r), (jsBoolDC, r)]

    let ng = mkNameGen []

    let lenv' = liftLanguageEnv nameGenT lenv
        fuzz = liftFuzz nameGenT lenv (fuzzFromValsAndOutputsM w fuzz_with'')
    (final_heap, is) <- evalNameGenT (livsSynthCVC4 config'' lenv' b fuzz fp cg cnst heap'' tenv synth_ex) ng

    -- mapM_ (liftIO . print . flip H.lookup final_heap . idName) is

    let finalFunc = concatMap (show . flip H.lookup final_heap . idName) is

    -- Provide function in JS
    let finalFuncJS = concatMap (\i -> case H.lookup (idName i) final_heap of
                                           Just (H.Def e) -> toJavaScriptDef S.empty (idName i) e
                                           _ -> error "livsSynth: No definition found") is

    return finalFuncJS
