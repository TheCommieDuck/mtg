--------------------------------------------------
-- Extensions ------------------------------------
--------------------------------------------------

{-# LANGUAGE PackageImports #-}

--------------------------------------------------

{- | Custom @Prelude@, for the @MTG.Classes.*@ modules.

Which themselves are re-exported by "MTG.Types.Prelude"
(the package-specific custom @Prelude@).

-}

module MTG.Classes.Prelude

  ( module EXPORT
  , module MTG.Classes.Prelude
  ) where

--------------------------------------------------
-- Exports ---------------------------------------
--------------------------------------------------

import "spiros" Prelude.Spiros as EXPORT

--------------------------------------------------
-- Types -----------------------------------------
--------------------------------------------------

-- | Association List.

type Assoc a = [( Text, a )]

--------------------------------------------------
-- EOF -------------------------------------------
--------------------------------------------------