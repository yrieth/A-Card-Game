extends Node

const FALLENLEORICINDEX: int = 11

@onready var isServer: bool = false
@onready var isClient: bool = false
@onready var port: int = 25565
@onready var ipAdress: String = "127.0.0.1"
var peerID: int
var gameNode: Control
@onready var yourTurn: bool = false
var deckToPlay: Array[int]


#Rarities from highest to lowest:
#1. N Nitro
#2. S Spirited
#3. n niotic
#4. b blazing
#5. s starter
const COLLECTION = [
	{
		Name = "Bum",
		Description = "Sometimes gets thrown into the battlefield",
		Attack = 1,
		Life = 1,
		Cost = 1,
		Rarity = "s",
		whenPlacedFunc = "",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Pacifist",
		Description = "When Dies: restores 4 life to both heroes",
		Attack = 2,
		Life = 2,
		Cost = 1,
		Rarity = "b",
		whenPlacedFunc = "",
		whenAttackFunc = "",
		whenDiesFunc = "whenDiesPacifist"
	},
	{
		Name = "Mole",
		Description = "",
		Attack = 1,
		Life = 3,
		Cost = 1,
		Rarity = "s",
		whenPlacedFunc = "",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Healing Beetle",
		Description = "When Dies: Restores 2 HP to your hero",
		Attack = 2,
		Life = 2,
		Cost = 2,
		Rarity = "s",
		whenPlacedFunc = "",
		whenAttackFunc = "",
		whenDiesFunc = "whenDiesHealingBeetle"
	},
	{
		Name = "Swamp lurker",
		Description = "",
		Attack = 2,
		Life = 3,
		Cost = 2,
		Rarity = "s",
		whenPlacedFunc = "",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Tech Aprentice",
		Description = "When Placed: Draw a card",
		Attack = 1,
		Life = 1,
		Cost = 2,
		Rarity = "n",
		whenPlacedFunc = "whenPlacedTechAprentice",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Beast Rider",
		Description = "When Placed: Awakens",
		Attack = 3,
		Life = 1,
		Cost = 3,
		Rarity = "b",
		whenPlacedFunc = "whenPlacedBeastRider",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Fatigued Mill",
		Description = "When Placed: Both players draw 2 cards",
		Attack = 2,
		Life = 2,
		Cost = 3,
		Rarity = "S",
		whenPlacedFunc = "whenPlacedFatiguedMill",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Restful Crystal",
		Description = "When Dies: Enemy draws a card",
		Attack = 4,
		Life = 4,
		Cost = 3,
		Rarity = "n",
		whenPlacedFunc = "",
		whenAttackFunc = "",
		whenDiesFunc = "whenDiesRestfulCrystal"
	},
	{
		Name = "Hungry Shark",
		Description = "",
		Attack = 4,
		Life = 5,
		Cost = 4,
		Rarity = "s",
		whenPlacedFunc = "",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Leoric",
		Description = "When Dies: Reincarnates once",
		Attack = 4,
		Life = 3,
		Cost = 5,
		Rarity = "N",
		whenPlacedFunc = "",
		whenAttackFunc = "",
		whenDiesFunc = "whenDiesLeoric"
	},
	{
		Name = "Fallen Leoric",
		Description = "",
		Attack = 4,
		Life = 3,
		Cost = 4,
		Rarity = "b",
		whenPlacedFunc = "",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Fried Chicken",
		Description = "When Placed: Summons two bums on enemy side, Awakens",
		Attack = 6,
		Life = 2,
		Cost = 5,
		Rarity = "S",
		whenPlacedFunc = "whenPlacedFriedChicken",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Math Teacher",
		Description = "When Placed: Choose an ally card, doubles its attack",
		Attack = 1,
		Life = 2,
		Cost = 4,
		Rarity = "S",
		whenPlacedFunc = "whenPlacedMathTeacher",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Renegade Rogue",
		Description = "When Placed: Choose an enemy card, deals 5 damage to it",
		Attack = 3,
		Life = 3,
		Cost = 5,
		Rarity = "n",
		whenPlacedFunc = "whenPlacedRenegadeRogue",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Void",
		Description = "When Placed: Deals 20 damage to all cards except Void",
		Attack = 1,
		Life = 1,
		Cost = 7,
		Rarity = "N",
		whenPlacedFunc = "whenPlacedVoid",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Sanok",
		Description = "When Placed: If this is your only card on field, choose an ally. Sets its life to 15",
		Attack = 5,
		Life = 1,
		Cost = 7,
		Rarity = "N",
		whenPlacedFunc = "whenPlacedSanok",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Gold Miner",
		Description = "When Dies: increases max gold by 1",
		Attack = 3,
		Life = 1,
		Cost = 3,
		Rarity = "b",
		whenPlacedFunc = "",
		whenAttackFunc = "",
		whenDiesFunc = "whenDiesGoldMiner"
	},
	{
		Name = "Bureaucrat",
		Description = "When Placed: increases max gold by 1",
		Attack = 3,
		Life = 4,
		Cost = 5,
		Rarity = "n",
		whenPlacedFunc = "whenPlacedBureaucrat",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Ancient",
		Description = "When Placed: sets enemy hero life to 1",
		Attack = 10,
		Life = 10,
		Cost = 10,
		Rarity = "N",
		whenPlacedFunc = "whenPlacedAncient",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Double Bomb",
		Description = "When Placed and When dies: deals 2 damage to all other cards",
		Attack = 2,
		Life = 1,
		Cost = 4,
		Rarity = "b",
		whenPlacedFunc = "whenPlacedDoubleBomb",
		whenAttackFunc = "",
		whenDiesFunc = "whenDiesDoubleBomb"
	},
	{
		Name = "Arcanist",
		Description = "When Placed: deals 1 damage to all enemy cards",
		Attack = 1,
		Life = 1,
		Cost = 3,
		Rarity = "n",
		whenPlacedFunc = "whenPlacedArcanist",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Pyromaniac",
		Description = "When Placed: choose an enemy, deals 6 damage to it, then deals 1 to itself",
		Attack = 1,
		Life = 1,
		Cost = 4,
		Rarity = "b",
		whenPlacedFunc = "whenPlacedPyromaniac",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Giant",
		Description = "",
		Attack = 8,
		Life = 9,
		Cost = 8,
		Rarity = "s",
		whenPlacedFunc = "",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Lava Hound",
		Description = "",
		Attack = 9,
		Life = 5,
		Cost = 7,
		Rarity = "s",
		whenPlacedFunc = "",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Drow Huntress",
		Description = "When Placed: choose an enemy card. Silances it",
		Attack = 4,
		Life = 3,
		Cost = 4,
		Rarity = "n",
		whenPlacedFunc = "whenPlacedDrowHuntress",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Blood Hound",
		Description = "When Placed: choose an ally card. Silances it. If this card is choosen deals 2 damage to itself instead",
		Attack = 3,
		Life = 3,
		Cost = 3,
		Rarity = "b",
		whenPlacedFunc = "whenPlacedBloodHound",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Ogr",
		Description = "",
		Attack = 6,
		Life = 7,
		Cost = 6,
		Rarity = "s",
		whenPlacedFunc = "",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Orc",
		Description = "",
		Attack = 3,
		Life = 4,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Reckless Fighter",
		Description = "When Dies: deals 8 damage to your hero",
		Attack = 6,
		Life = 3,
		Cost = 4,
		Rarity = "b",
		whenPlacedFunc = "",
		whenAttackFunc = "",
		whenDiesFunc = "whenDiesRecklessFighter"
	},
	{
		Name = "Furious Ursa",
		Description = "When Attacks: increases its attack by 1",
		Attack = 1,
		Life = 5,
		Cost = 4,
		Rarity = "n",
		whenPlacedFunc = "",
		whenAttackFunc = "whenAttackFuriousUrsa",
		whenDiesFunc = ""
	},
	{
		Name = "Lesser Ursa",
		Description = "When Dies: increases all ally cards attack by 1",
		Attack = 3,
		Life = 2,
		Cost = 3,
		Rarity = "b",
		whenPlacedFunc = "",
		whenAttackFunc = "",
		whenDiesFunc = "whenDiesLesserUrsa"
	},
	{
		Name = "Healing Statue",
		Description = "When Attacks: heals the enemy for double the amount of its attack",
		Attack = 3,
		Life = 5,
		Cost = 2,
		Rarity = "s",
		whenPlacedFunc = "",
		whenAttackFunc = "whenAttackHealingStatue",
		whenDiesFunc = ""
	},
	{
		Name = "Silancer",
		Description = "When Placed: silances all other cards",
		Attack = 4,
		Life = 4,
		Cost = 5,
		Rarity = "N",
		whenPlacedFunc = "whenPlacedSilancer",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Wise Owl",
		Description = "When Placed: choose an enemy card. Silances it",
		Attack = 2,
		Life = 1,
		Cost = 3,
		Rarity = "n",
		whenPlacedFunc = "whenPlacedDrowHuntress",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Confused Owl",
		Description = "When Placed: choose an ally card. Silances it",
		Attack = 2,
		Life = 3,
		Cost = 3,
		Rarity = "b",
		whenPlacedFunc = "whenPlacedConfusedOwl",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Bum Bum",
		Description = "When Dies: summons a bum",
		Attack = 1,
		Life = 1,
		Cost = 1,
		Rarity = "s",
		whenPlacedFunc = "",
		whenAttackFunc = "",
		whenDiesFunc = "whenDiesBumBum"
	},
	{
		Name = "Beggar Union",
		Description = "When Dies: summons 2 bums",
		Attack = 2,
		Life = 2,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "",
		whenAttackFunc = "",
		whenDiesFunc = "whenDiesBeggarUnion"
	},
	{
		Name = "Talking drawer",
		Description = "When Placed and When Dies: draw a card",
		Attack = 3,
		Life = 5,
		Cost = 6,
		Rarity = "n",
		whenPlacedFunc = "whenPlacedTechAprentice",
		whenAttackFunc = "",
		whenDiesFunc = "whenPlacedTechAprentice"
	},
	{
		Name = "A wall",
		Description = "",
		Attack = 0,
		Life = 10,
		Cost = 3,
		Rarity = "b",
		whenPlacedFunc = "",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Vengeful Wasp",
		Description = "When Attacks: Also deals damage to enemy hero",
		Attack = 3,
		Life = 2,
		Cost = 4,
		Rarity = "n",
		whenPlacedFunc = "",
		whenAttackFunc = "whenAttackVengefulWasp",
		whenDiesFunc = ""
	},
	{
		Name = "Bes",
		Description = "When Placed: Deals 2 damage to your hero",
		Attack = 3,
		Life = 2,
		Cost = 1,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedBes",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Traitor Prist",
		Description = "When Placed: Restores 3 life to enemy hero",
		Attack = 3,
		Life = 3,
		Cost = 2,
		Rarity = "b",
		whenPlacedFunc = "whenPlacedTraitorPriest",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Fellow Prist",
		Description = "When Placed: Restores 7 life to your hero",
		Attack = 1,
		Life = 1,
		Cost = 3,
		Rarity = "S",
		whenPlacedFunc = "whenPlacedFellowPriest",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Gold Mine",
		Description = "When Placed: Temporary get the sum of costs of your cards on board as gold",
		Attack = 0,
		Life = 3,
		Cost = 8,
		Rarity = "N",
		whenPlacedFunc = "whenPlacedGoldMine",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Sneaky Trader",
		Description = "When Placed: Get a copy of a random card in your hand",
		Attack = 2,
		Life = 3,
		Cost = 4,
		Rarity = "b",
		whenPlacedFunc = "whenPlacedSneakyTrader",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Value Dealer",
		Description = "When Placed: Get a copy of each card in your hand",
		Attack = 3,
		Life = 3,
		Cost = 6,
		Rarity = "N",
		whenPlacedFunc = "whenPlacedValueDealer",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Lawful Merchant",
		Description = "When Placed: Get a copy of your left most card in hand",
		Attack = 1,
		Life = 3,
		Cost = 4,
		Rarity = "n",
		whenPlacedFunc = "whenPlacedLawfulMerchant",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Cartographer",
		Description = "When Placed: Choose an ally card. Shuffles a copy of it into your deck, can't shuffle itself",
		Attack = 2,
		Life = 2,
		Cost = 3,
		Rarity = "b",
		whenPlacedFunc = "whenPlacedCartographer",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Cornifer",
		Description = "When Placed: Shuffles 3 random copies of cards from your hand",
		Attack = 3,
		Life = 3,
		Cost = 5,
		Rarity = "S",
		whenPlacedFunc = "whenPlacedCornifer",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	
]
