extends Control

@onready var deckToPlay = Global.deckToPlay.duplicate()
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
	Card.whenDiesFunctions = %whenDiesFunctions
	Card.EnemyPlace = %EnemyPlace
	Card.YourPlace = %YourPlace
	
	

func assign_id(id: int) -> void:
	Global.peerID = id

@rpc("any_peer")
func change_turn() -> void:
	$EndTurnButton.disabled = Global.yourTurn
	Global.yourTurn = !Global.yourTurn
	if Global.yourTurn:
		$YourHand/TurnDisplay.tooltip_text = "Your Turn"
		$YourHand/TurnDisplay.value = 1
	else:
		$YourHand/TurnDisplay.tooltip_text = "Enemy Turn"
		$YourHand/TurnDisplay.value = 0

	#For start and end turn mechanics
	if Global.yourTurn:
		if maxGold < 8:
			maxGold += 1
		gold = maxGold
		%YourHand.update_gold()
		%YourHand.draw_card()
		for card:Card in %YourPlace.cardSlots:
			if card!=null:
				card.asleep = false
	else :
		pass


func start_game(_id: int)->void:
	gold = maxGold
	deckToPlay.shuffle()
	if Global.isServer:
		if randf() > 0.5:
			change_turn()
		else :
			multiplayer.rpc(Global.peerID, self, "change_turn")

func end_game()->void:
	multiplayer.multiplayer_peer = null
	Global.isClient = false
	Global.isServer = false
	Global.peerID = 0
	Global.yourTurn = false
	#Code goes before this command
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

@rpc("any_peer")
func card_methods_rpc(methodToCall: String, amount: int, yours: bool, slot: int):
	var nodeToPerformOn: Control
	if yours:
		nodeToPerformOn = %YourPlace
	else:
		nodeToPerformOn = %EnemyPlace
	match methodToCall:
		"get_damaged":
			nodeToPerformOn.cardSlots[slot].get_damaged(amount, yours, slot)
		"change_max_life":
			nodeToPerformOn.cardSlots[slot].change_max_life(amount)
		"change_current_attack":
			nodeToPerformOn.cardSlots[slot].change_current_attack(amount)
		"change_current_cost":
			nodeToPerformOn.cardSlots[slot].change_current_cost(amount)

func _on_you_win_button_pressed() -> void:
	#Code goes before this command
	end_game()
	

func _on_you_lose_button_pressed() -> void:
	#Code goes before this command
	end_game()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		$ConcedeButton.visible = !$ConcedeButton.visible
