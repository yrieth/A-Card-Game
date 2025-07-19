extends Control


const MAX_CLIENTS = 1
@onready var maxGold = 0
var gold: int
@onready var placeSelected: bool = false
@onready var enemySelected: bool = false

func _ready() -> void:
	Global.gameNode = self
	var peer = ENetMultiplayerPeer.new()
	if Global.isServer:
		peer.create_server(Global.port, MAX_CLIENTS)
		multiplayer.multiplayer_peer = peer
		multiplayer.peer_connected.connect(assign_id)
	elif Global.isClient:
		peer.create_client(Global.ipAdress, Global.port)
		multiplayer.multiplayer_peer = peer
		Global.peerID = 1
	
	multiplayer.peer_connected.connect(start_game)
	print(Global.ipAdress + ':' + str(Global.port))
	Card.whenPlacedFunctions = %whenPlacedFunctions
	Card.whenAttackFunctions = %whenAttackFunctions
	
	

func assign_id(id: int) -> void:
	Global.peerID = id

@rpc("any_peer")
func change_turn() -> void:
	$EndTurnButton.disabled = Global.yourTurn
	Global.yourTurn = !Global.yourTurn
	$TurnDisplay.text = "Your turn: " + str(Global.yourTurn)

	#For start and end turn mechanics
	if Global.yourTurn:
		maxGold += 1
		gold = maxGold
		%YourHand.update_gold()
		%YourHand.get_card()
		for card:Card in %YourPlace.cardSlots:
			if card!=null:
				card.asleep = false
	else :
		pass


func start_game(_id: int)->void:
	gold = maxGold
	if Global.isServer:
		if randf() > 0.5:
			change_turn()
		else :
			multiplayer.rpc(Global.peerID, self, "change_turn")
