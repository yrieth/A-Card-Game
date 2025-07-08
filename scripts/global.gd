extends Node


const COLLECTION = [
	{
		Name = "Name",
		Description = "",
		Life = 1,
		Attack = 1,
		Cost = 1
	},
	{
		Name = "Something",
		Description = "None",
		Life = 3,
		Attack = 3,
		Cost = 3
	}
]

@onready var isServer: bool = false
@onready var isClient: bool = false
@onready var port = 25565
@onready var ipAdress = "127.0.0.1"
var peerID
