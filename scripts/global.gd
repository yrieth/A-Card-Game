extends Node


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
		Name = "Name",
		Description = "",
		Life = 1,
		Attack = 1,
		Cost = 1,
		Rarity = "s",
		whenPlacedFunc = "",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Something",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "b",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "AnotherCard",
		Description = "None",
		Life = 3,
		Attack = 2,
		Cost = 2,
		Rarity = "n",
		whenPlacedFunc = "",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Something1",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "S",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Something2",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "N",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Something3",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Something4",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Something5",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Something6",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Something7",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Something8",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Something9",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Something10",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Something11",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Something12",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Something13",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Something14",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Something15",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Something16",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Something17",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Something18",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Something19",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
	{
		Name = "Something20",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3,
		Rarity = "s",
		whenPlacedFunc = "whenPlacedSomething",
		whenAttackFunc = "",
		whenDiesFunc = ""
	},
]
