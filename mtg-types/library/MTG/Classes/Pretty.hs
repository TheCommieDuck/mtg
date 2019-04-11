
--------------------------------------------------
--------------------------------------------------

{-| 

== Implementation

The 'CharParsing' @class@ from the @parser@ package has @instance@s for:

* @attoparsec@ — used by @mtg-json@ (via the @aeson@ package).
* @trifecta@ — used for pretty-printed parse-errors (e.g. @ANSI@ color codes, “caret diagnostics”).
* @base@'s "Text.Read" — useful for simple and\/or standalone examples (e.g. in @doctest@s).

-}

module MTG.Classes.Pretty

  ( module MTG.Classes.Pretty

  , Parsing
  , CharParsing
  ) where

--------------------------------------------------
-- Imports ---------------------------------------
--------------------------------------------------

import "spiros" Prelude.Spiros

--------------------------------------------------
-- Imports ---------------------------------------
--------------------------------------------------

import "parsers" Text.Prettyr.Combinators ( Parsing )
import "parsers" Text.Prettyr.Char        ( CharParsing )
--import "parsers" Text.Prettyr.Token       ( TokenParsing )

--import qualified "parsers" Text.Prettyr.Combinators as P
import qualified "parsers" Text.Prettyr.Char        as P

--------------------------------------------------
-- Types -----------------------------------------
--------------------------------------------------

-- | Association List.

type Assoc a = [( Text, a )]

--------------------------------------------------
-- Classes ---------------------------------------
--------------------------------------------------

{-| Canonical parsing for @mtg-types@.

== Implementation

These typeclasses' methods are available 'parser' implementations:

* 'CharParsing'
* 'Parsing'
* 'Alternative'
* 'Applicative'
* 'Functor'

-}

class Pretty a where

  parser :: CharParsing m => m a

--------------------------------------------------
-- Constants -------------------------------------
--------------------------------------------------

--------------------------------------------------
-- Functions -------------------------------------
--------------------------------------------------

{-| 

-}

pAssoc :: (CharParsing m) => Assoc a -> m a
pAssoc kvs = do

  let pKvs = (pPair <$> kvs)

  (foldr (<|>) empty) pKvs

  where

  pPair (k,v) = v <$ P.text k

--------------------------------------------------
-- EOF -------------------------------------------
--------------------------------------------------