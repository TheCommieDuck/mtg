--------------------------------------------------
-- Extensions ------------------------------------
--------------------------------------------------

{-# LANGUAGE TemplateHaskell #-}

--------------------------------------------------

{-# LANGUAGE GeneralizedNewtypeDeriving #-}

--------------------------------------------------

{-| 'CMC' abbreviates /converted mana cost/.

-}

module MTG.Number.CMC where

--------------------------------------------------
-- Imports ---------------------------------------
--------------------------------------------------

import MTG.Types.Prelude

--------------------------------------------------
-- Imports ---------------------------------------
--------------------------------------------------

import "lens" Control.Lens (makePrisms)

--------------------------------------------------

--import qualified "prettyprinter" Data.Text.Prettyprint.Doc               as PP
--import qualified "prettyprinter" Data.Text.Prettyprint.Doc.Render.String as PP.String

--------------------------------------------------

--import qualified "text" Data.Text as Text

--------------------------------------------------
-- Types -----------------------------------------
--------------------------------------------------

{-| 

-}

newtype CMC = CMC

  Natural

  deriving stock    (Show,Read)
  deriving stock    (Lift,Data,Generic)

  deriving newtype  (Num)
  deriving newtype  (Eq,Ord)
  deriving newtype  (NFData,Hashable)

--------------------------------------------------

-- | @= 'cmcAdd'@
instance Semigroup CMC where (<>)   = cmcAdd

-- | @= 'CMC0'@
instance Monoid    CMC where mempty = CMC0

--------------------------------------------------

-- | @= 'defaultCMC'@
instance Default CMC where def = defaultCMC

--------------------------------------------------
-- Patterns --------------------------------------
--------------------------------------------------

-- | @= 0@
pattern CMC0 :: CMC
pattern CMC0 = CMC 0

--------------------------------------------------
-- Constants -------------------------------------
--------------------------------------------------

{- | @= 0@

By default, cards with no mana cost (like lands) have zero /converted mana cost/.

-}

defaultCMC :: CMC
defaultCMC = CMC0

--------------------------------------------------
-- Functions -------------------------------------
--------------------------------------------------

{- | @= ('+')@

Mana costs, when combined, are (almost always) /added/ together.
c.f. /split cards/ like:

* the @Fire \/\/ Ice@ card.
* the @Fuse@ mechanic.
* the @Aftermath@ mechanic.

== Notes

From the /Comprehensive Rules/:

* >708.4. In every zone except the stack, the characteristics of a split card are those of its two halves combined. This is a change from previous rules.

    * >708.4a Each split card has two names. If an effect instructs a player to choose a card name and the player wants to choose a split card's name, the player must choose one of those names and not both. An object has the chosen name if one of its names is the chosen name.
    * >708.4b The mana cost of a split card is the combined mana costs of its two halves. A split card's colors and converted mana cost are determined from its combined mana cost.

        >Example: Assault/Battery's mana cost is {3}{R}{G}. It's a red and green card with a converted mana cost of 5. If you cast Assault, the resulting spell is a red spell with a converted mana cost of 1.

    * >708.4c A split card has each card type specified on either of its halves and each ability in the text box of each half.
    * >708.4d The characteristics of a fused split spell on the stack are also those of its two halves combined (see rule 702.101, "Fuse").
    * >708.4b The mana cost of a split card is the combined mana costs of its two halves. A split card's colors and converted mana cost are determined from its combined mana cost. Example: Assault/Battery's mana cost is {3}{R}{G}. It's a red and green card with a converted mana cost of 5.

-}

cmcAdd :: CMC -> CMC -> CMC 
cmcAdd = coerce ((+) :: Natural -> Natural -> Natural)

--------------------------------------------------
-- Optics ----------------------------------------
--------------------------------------------------

makePrisms ''CMC

--------------------------------------------------
-- EOF -------------------------------------------
--------------------------------------------------