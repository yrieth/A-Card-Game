extends Node

const COLLECTION = [
	{
		Name = "Name",
		Description = "",
		Life = 1,
		Attack = 1,
		Cost = 1,
		whenPlacedFunc = "",
		whenAttackFunc = ""
	},
	{
		Name = "Something",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = ""
	},
	{
		Name = "AnotherCard",
		Description = "None",
		Life = 3,
		Attack = 2,
		Cost = 2,
		whenPlacedFunc = "",
		whenAttackFunc = ""
	}
]

var unlockedCards: Dictionary[String, bool]
@onready var isServer: bool = false
@onready var isClient: bool = false
@onready var port: int = 25565
@onready var ipAdress: String = "127.0.0.1"
var peerID: int
var gameNode: Control
@onready var yourTurn: bool = false

func _ready() -> void:
	var unlockedCardsFile: FileAccess = FileAccess.open("res://saves/unlockedCards.save", FileAccess.READ)
	if unlockedCardsFile == null or !unlockedCardsFile.is_open():
		unlockedCardsFile = FileAccess.open("res://saves/unlockedCards.save", FileAccess.WRITE)
		for i in COLLECTION:
			unlockedCards.get_or_add(i.Name, false)
		unlockedCardsFile.store_var(unlockedCards)
		unlockedCardsFile.close()
	unlockedCardsFile = FileAccess.open("res://saves/unlockedCards.save", FileAccess.READ)
	unlockedCards = unlockedCardsFile.get_var()
	print(unlockedCards)
