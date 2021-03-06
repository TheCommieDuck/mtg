# Notes about `mtg-json`

## JSON Schemata

### Cards

*JSON Schema* for **card**s:

``` json
  {
    {
    
      "artist": {
        "type": "string",
        "example": "\"Ryan Yee\"",
        "description": "Name of the artist that illustrated the card art."
      },
    
      "borderColor": {
        "type": "string",
        "example": "\"black\"",
        "description": "Color of the border. Can be {{code:black}}, {{code:borderless}}, {{code:gold}}, {{code:silver}} or {{code:white}}."
      },
    
      "colorIdentity": {
        "type": "array(string)",
        "example": "[\"B\"]",
        "description": "List of all colors in card’s mana cost, rules text and any color indicator."
      },
    
      "colorIndicator": {
        "type": "array(string)",
        "example": "[\"B\",\"R\"]",
        "description": "List of all colors in card’s color indicator (a symbol showing the colors of the card). Usually found only on cards without mana costs and other special cards."
      },
    
      "colors": {
        "type": "array(string)",
        "example": "[\"B\",\"R\"]",
        "description": "List of all colors in card’s mana cost and any color indicator. Some cards are special (such as Devoid cards or other cards with certain rules text)."
      },
    
      "convertedManaCost": {
        "type": "float",
        "example": "5.0",
        "description": "The converted mana cost of the card."
      },
    
      "duelDeck": {
        "type": "string",
        "example": "\"a\"",
        "description": "If the card is in a duel deck product, can be {{code:a}}(left) or {{code:b}}(right). (If not in duel deck product, duelDeck is usually ommitted.)"
      },
    
      "faceConvertedManaCost": {
        "type": "float",
        "example": "5.0",
        "description": "The converted mana cost of the face of either half or part of the card."
      },
    
      "flavorText": {
        "type": "string",
        "example": "\"Whatever hatred destroys, a single act of trust can revive.\"",
        "description": "Italicized text found below the rules text that has no game function."
      },
    
      "foreignData": {
        "type": "array(object)",
        "example": "{{link:foreign-data}}",
        "description": "See the {{link:foreign-data}} structure."
      },
    
      "frameEffect": {
        "type": "string",
        "example": "\"legendary\"",
        "description": "Values can be {{code:colorshifted}}, {{code:compasslanddfc}}, {{code:devoid}}, {{code:draft}}, {{code:legendary}}, {{code:miracle}}, {{code:mooneldrazidfc}}, {{code:nyxtouched}}, {{code:originpwdfc}}, {{code:sunmoondfc}} or {{code:tombstone}}."
      },
    
      "frameVersion": {
        "type": "string",
        "example": "\"2015\"",
        "description": "Version of the card frame style. Can be {{code:1993}}, {{code:1997}}, {{code:2003}}, {{code:2015}} or {{code:future}}."
      },
    
      "hand": {
        "type": "string",
        "example": "\"+0\"",
        "description": "Starting maximum hand size total modifier. A plus or minus character preceeds an integer. Used only on Vanguard cards."
      },
    
      "hasFoil": {
        "type": "boolean",
        "example": "true",
        "description": "Can the card be found in foil? (If false, it is usually omitted.)"
      },
    
      "hasNonFoil": {
        "type": "boolean",
        "example": "true",
        "description": "Can the card be found in non-foil? (If false, it is usually omitted.)"
      },
    
      "isOnlineOnly": {
        "type": "boolean",
        "example": "false",
        "description": "Is the card only available online? (If false, it is usually omitted.)"
      },
    
      "isOversized": {
        "type": "boolean",
        "example": "false",
        "description": "Is the card oversized? (If false, it is usually omitted.)"
      },
    
      "isReserved": {
        "type": "boolean",
        "example": "false",
        "description": "Is the card on the MTG Reserved List? (If false, it is usually omitted.)"
      },
    
      "isStarter": {
        "type": "boolean",
        "example": "false",
        "description": "If this card is found in a booster pack. (If false, it is usually omitted.)"
      },
    
      "isTimeshifted": {
        "type": "boolean",
        "example": "false",
        "description": "Card is “timeshifted”, a feature from Time Spiral block. (If false, it is usually omitted.)"
      },
    
      "layout": {
        "type": "string",
        "example": "\"normal\"",
        "description": "Type of card layout. Can be {{code:normal}}, {{code:split}}, {{code:flip}}, {{code:transform}}, {{code:meld}}, {{code:leveler}}, {{code:saga}}, {{code:planar}}, {{code:scheme}}, {{code:vanguard}}, {{code:token}}, {{code:double_faced_token}}, {{code:emblem}}, {{code:augment}} or {{code:host}}. (If normal, it is usually omitted.)"
      },
    
      "legalities": {
        "type": "object",
        "example": "{{link:legalities}}",
        "description": "See the {{link:legalities}} structure."
      },
    
      "life": {
        "type": "string",
        "example": "\"+0\"",
        "description": "Starting life total modifier. A plus or minus character preceeds an integer. Used only on Vanguard cards."
      },
    
      "loyalty": {
        "type": "string",
        "example": "\"7\"",
        "description": "Planeswalker loyalty value."
      },
    
      "manaCost": {
        "type": "string",
        "example": "\"{3}{W}{W}\"",
        "description": "Mana cost of the card."
      },
    
      "multiverseId": {
        "type": "integer",
        "example": "457145",
        "description": "An integer most cards have which Wizards uses as a card identifier."
      },
    
      "name": {
        "type": "string",
        "example": "\"Angel of Grace\"",
        "description": "Name of the card. (If the card is in an Un-set and has multiple printings, a space and letter enclosed in parentheses, starting with (b), follows the name.)"
      },
    
      "names": {
        "type": "array(string)",
        "example": "[\"Nicol Bolas, the Ravager\",\"Nicol Bolas, the Arisen\"]",
        "description": "Names of each face on the card. Meld cards are listed in the order of CardA, Meld, CardB."
      },
    
      "number": {
        "type": "string",
        "example": "\"218\"",
        "description": "Number of the card."
      },
    
      "originalText": {
        "type": "string",
        "example": "\"Reach (This creature can block creatures with flying.)\\nDeathtouch (Any amount of damage this deals to a creature is enough to destroy it.)\"",
        "description": "Text on the card as originally printed."
      },
    
      "originalType": {
        "type": "string",
        "example": "\"Legendary Creature — Angel\"",
        "description": "Type as originally printed. Includes any supertypes and subtypes. (\"Legendary Creature — Angel\")"
      },
    
      "power": {
        "type": "string",
        "example": "\"5\"",
        "description": "Power of the creature."
      },
    
      "printings": {
        "type": "array(string)",
        "example": "[\"M19\",\"PM19\"]",
        "description": "List of sets the card was printed in, in uppercase."
      },
    
      "rarity": {
        "type": "string",
        "example": "\"mythic\"",
        "description": "Rarity. Can be basic, common, uncommon, rare or mythic"
      },
    
      "rulings": {
        "type": "array(object)",
        "example": "{{link:rulings}}",
        "description": "See the {{link:rulings}} structure."
      },
    
      "scryfallId": {
        "type": "string",
        "example": "\"80164e61-3e94-4e10-9bd1-518b8dc7fc4c\"",
        "description": "A universal unique id (v4) generated by Scryfall. Note that cards with multiple faces are not unique."
      },
    
      "scryfallOracleId": {
        "type": "string",
        "example": "\"9b7870df-6bca-499f-bc6e-e57f2ddfe640\"",
        "description": "A unique ID for this card’s oracle identity. This value is consistent across reprinted card editions, and unique among different cards with the same name (tokens, Unstable variants, etc)."
      },
    
      "scryfallIllustrationId": {
        "type": "string",
        "example": "\"4ab49865-ff4c-4dae-94e8-a5ce273138da\"",
        "description": "A unique identifier for the card artwork that remains consistent across reprints. Newly spoiled cards may not have this field yet."
      },
    
      "side": {
        "type": "string",
        "example": "\"a\"",
        "description": "Identifier of the side. Used on cards with multiple faces, such as flip, split, transform cards. Can be {{code:a}}, {{code:b}} or {{code:c}}."
      },
    
      "subtypes": {
        "type": "array(string)",
        "example": "[\"Angel\"]",
        "description": "List of card subtypes found after em-dash. (\"Legendary Creature — Angel\")"
      },
    
      "supertypes": {
        "type": "array(string)",
        "example": "[\"Legendary\"]",
        "description": "List of card supertypes found before em-dash. (\"Legendary Creature — Angel\")"
      },
    
      "tcgplayerProductId": {
        "type": "integer",
        "example": "183201",
        "description": "Numeric identifier for the card for TCGPlayer."
      },
    
      "tcgplayerPurchaseUrl": {
        "type": "string",
        "example": "\"https://mtgjson.com/links/c9231e9296c7917d\"",
        "description": "URL which redirects to TCGPlayer website’s card page."
      },
    
      "text": {
        "type": "string",
        "example": "\"Reach (This creature can block creatures with flying.)\\nDeathtouch (Any amount of damage this deals to a creature is enough to destroy it.)\"",
        "description": "Rules text of the card."
      },
    
      "toughness": {
        "type": "string",
        "example": "\"4\"",
        "description": "Toughness of the card."
      },
    
      "type": {
        "type": "string",
        "example": "\"Legendary Creature — Angel\"",
        "description": "Type of the card. Includes any supertypes and subtypes. (\"Creature — Angel\")"
      },
    
      "types": {
        "type": "array(string)",
        "example": "[\"Creature\"]",
        "description": "List of types of the card."
      },
    
      "uuid": {
        "type": "string",
        "example": "\"7eb0f276-5e32-5a1e-acfd-9b0ddc19b845\"",
        "description": "A universal unique id (v5) generated by MTGJSON. Each entry is unique."
      },
    
      "uuidV421": {
        "type": "string",
        "example": "\"c095a153-6bbf-5e93-8a68-578d17461170\"",
        "description": "Compatibility uuid for v4.3.0, but will support v4.2.1 to help people transition until v4.4.0."
      },
    
      "variations": {
        "type": "array(string)",
        "example": "[\"7eb0f276-5e32-5a1e-acfd-9b0ddc19b845\"]",
        "description": "List of uuid id's of this card with alternate printings in the same set. Excludes Un-sets."
      },
    
      "watermark": {
        "type": "string",
        "example": "\"wotc\"",
        "description": "Name of the watermark on the card. If there isn’t one, it can be an empty string, but it is usually omitted."
      }
    
    }
```

e.g. **card**:

``` json
  {

    "artist": "Jeff A. Menges",
    "borderColor": "black",
    "colorIdentity": [
        "B"
    ],
    "colors": [
        "B"
    ],
    "convertedManaCost": 3,
    "flavorText": "They say the Zombie Master controlled these foul creatures even before his own death, but now that he is one of them, nothing can make them betray him.",
    "foreignData": [],
    "frameVersion": "1993",
    "hasFoil": false,
    "hasNonFoil": true,
    "layout": "normal",
    "legalities": {
        "commander": "Legal",
        "duel": "Legal",
        "legacy": "Legal",
        "oldschool": "Legal",
        "vintage": "Legal"
    },
    "manaCost": "{1}{B}{B}",
    "multiverseId": 93,
    "name": "Zombie Master",
    "number": "137",
    "originalText": "All zombies in play gain swampwalk and \"ooB Regenerates\" for as long as this card remains in play.",
    "originalType": "Summon - Lord",
    "power": "2",
    "printings": [
        "2ED",
        "3ED",
        "4ED",
        "5ED",
        "6ED",
        "CED",
        "CEI",
        "FBB",
        "LEA",
        "LEB",
        "ME4",
        "SUM"
    ],
    "rarity": "rare",
    "rulings": [],
    "scryfallId": "3d4255a0-d445-4c00-b936-bbf07851e1c8",
    "scryfallIllustrationId": "7441c48a-ca5a-415c-ad9d-2839e6e47f5b",
    "scryfallOracleId": "5446c92f-ff22-4e9b-a2f6-e64c8560c1e0",
    "subtypes": [
        "Zombie"
    ],
    "supertypes": [],
    "tcgplayerProductId": 1326,
    "tcgplayerPurchaseUrl": "https://mtgjson.com/links/32718321fcedd1bc",
    "text": "Other Zombie creatures have swampwalk. (They can't be blocked as long as defending player controls a Swamp.)\nOther Zombies have \"{B}: Regenerate this permanent.\"",
    "toughness": "3",
    "type": "Creature — Zombie",
    "types": [
        "Creature"
    ],
    "uuid": "ad86cf17-89fc-5171-a8ef-eac823be8660",
    "uuidV421": "32ab9e53-c679-5166-9e0c-fcca266dbbf8"
```

### Sets (of Cards)

*JSON Schema* for **set**s:

``` json
```

## 
