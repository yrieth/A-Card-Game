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
	}
]

@onready var isServer: bool = false
@onready var isClient: bool = false
@onready var port: int = 25565
@onready var ipAdress: String = "127.0.0.1"
var peerID: int
var gameNode: Control
@onready var yourTurn: bool = false


#@rpc("any_peer")
#func rpc_turn_change() ->void:
	#yourTurn = true
	#$EndTurnButton.disabled = yourTurn
	#$TurnDisplay.text = "Your turn: " + str(yourTurn)
