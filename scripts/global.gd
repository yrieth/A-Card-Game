extends Node

var unlockedCards: Dictionary[String, bool]
@onready var isServer: bool = false
@onready var isClient: bool = false
@onready var port: int = 25565
@onready var ipAdress: String = "127.0.0.1"
var peerID: int
var gameNode: Control
@onready var yourTurn: bool = false
var deckToPlay: Array[int]

func _ready() -> void:
	var unlockedCardsFile: FileAccess = FileAccess.open("res://saves/unlockedCards.save", FileAccess.READ)
	if unlockedCardsFile == null:
		unlockedCardsFile = FileAccess.open("res://saves/unlockedCards.save", FileAccess.WRITE)
		for i in COLLECTION:
			unlockedCards.get_or_add(i.Name, false)
		unlockedCardsFile.store_var(unlockedCards)
		unlockedCardsFile.close()
		unlockedCardsFile = FileAccess.open("res://saves/unlockedCards.save", FileAccess.READ)
	unlockedCards = unlockedCardsFile.get_var()
	print(unlockedCards)


const COLLECTION = [
	{
		Name = "Name",
		Description = "",
		Life = 1,
		Attack = 1,
		Cost = 1,
		Rarity = "s",
		whenPlacedFunc = "",
		whenAttackFunc = ""
	},
	{
		Name = "Something",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "b",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = ""
	},
	{
		Name = "AnotherCard",
		Description = "None",
		Life = 3,
		Attack = 2,
		Cost = 2,
		Rarity = "n",
		whenPlacedFunc = "",
		whenAttackFunc = ""
	},
	{
		Name = "Something1",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "S",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = ""
	},
	{
		Name = "Something2",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "N",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = ""
	},
	{
		Name = "Something3",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = ""
	},
	{
		Name = "Something4",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = ""
	},
	{
		Name = "Something5",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = ""
	},
	{
		Name = "Something6",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = ""
	},
	{
		Name = "Something7",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = ""
	},
	{
		Name = "Something8",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = ""
	},
	{
		Name = "Something9",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = ""
	},
	{
		Name = "Something10",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = ""
	},
	{
		Name = "Something11",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = ""
	},
	{
		Name = "Something12",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = ""
	},
	{
		Name = "Something13",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = ""
	},
	{
		Name = "Something14",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = ""
	},
	{
		Name = "Something15",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = ""
	},
	{
		Name = "Something16",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = ""
	},
	{
		Name = "Something17",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = ""
	},
	{
		Name = "Something18",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = ""
	},
	{
		Name = "Something19",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = ""
	},
	{
		Name = "Something20",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = ""
	},
]
