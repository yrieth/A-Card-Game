extends Node

const FALLENLEORICINDEX: int = 8

@onready var isServer: bool = false
@onready var isClient: bool = false
@onready var port: int = 25565
@onready var ipAdress: String = "127.0.0.1"
var peerID: int
var gameNode: Control
@onready var yourTurn: bool = false
var deckToPlay: Array[int]


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
		Description = "When Dies: Restore 2 HP to your hero",
		Attack = 2,
		Life = 3,
		Cost = 2,
		Rarity = "s",
		whenPlacedFunc = "",
		whenAttackFunc = "",
		whenDiesFunc = "whenDiesHealingBeetle"
	},
	{
		Name = "Tech Aprentice",
		Description = "When Placed: Draw a car",
		Attack = 1,
		Life = 1,
		Cost = 2,
		Rarity = "s",
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
		Rarity = "s",
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
		Rarity = "s",
		whenPlacedFunc = "whenPlacedFatiguedMill",
		whenAttackFunc = "",
		whenDiesFunc = ""
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
		Rarity = "s",
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
		Rarity = "s",
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
		Rarity = "s",
		whenPlacedFunc = "whenPlacedFriedChicken",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Math Teacher",
		Description = "When Placed: Choose an ally card, double its attack",
		Attack = 1,
		Life = 2,
		Cost = 4,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedMathTeacher",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Renegade Rogue",
		Description = "When Placed: Choose an enemy card, deal 5 damage to it",
		Attack = 3,
		Life = 3,
		Cost = 5,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedRenegadeRogue",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	
	
]
