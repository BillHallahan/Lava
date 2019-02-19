{
module Lava.Target.OCaml.ParserCL ( parse ) where

import Lava.Language.Syntax
import Lava.Target.OCaml.LexerCL
}

%name parse
%tokentype { Token }
%error { parseError }

%token
    int         { TokenInt $$ }

%%

expr :: { Expr }
     : int { Lit (LInt $1) }

{
parseError :: [Token] -> a
parseError _ = error "Parse error."
}