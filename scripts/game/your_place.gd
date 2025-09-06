extends Control

const SLOT_POSITIONS: Array[int] = [8, 8+24+120, 8+2*24+120*2, 8+3*24+120*3, 8+4*24+120*4]
@onready var cardSlots: Array[Card] = [null, null, null, null, null]
@onready var focusedPlaceCard: int = -1
@onready var focusedEnemyCard: int = -1

func put_card(card: Card, slot:int, fromHand: bool = true) -> void:
	var cardTween: Tween = create_tween()
	cardTween.set_trans(Tween.TRANS_CUBIC)
	cardSlots[slot] = card
	if fromHand:
		get_parent().gold -= card.cost
		%YourHand.update_gold()
		%YourHand.remove_focused()
		card.whenPlaced()
	self.add_child(card)
	card.position += Vector2(-232, -288+512)
	cardTween.tween_property(card, "position", Vector2(SLOT_POSITIONS[slot], 8), 0.5)
	multiplayer.rpc(Global.peerID, %EnemyPlace, "put_card", [card.cardId,slot])
	#Signals
	card.connect("button_down", make_focused.bind(slot))
	card.connect("button_up", make_attack)
	
@rpc("any_peer")
func put_card_rpc(cardId: int, slot: int) -> void:
	var card: Card = Card.new()
	card.get_values(cardId)
	var cardTween: Tween = create_tween()
	cardTween.set_trans(Tween.TRANS_CUBIC)
	cardSlots[slot] = card
	self.add_child(card)
	card.position += Vector2(-232, -288+512)
	cardTween.tween_property(card, "position", Vector2(SLOT_POSITIONS[slot], 8), 0.5)
	card.whenPlaced()
	#Signals
	card.connect("button_down", make_focused.bind(slot))
	card.connect("button_up", make_attack)
	
func make_focused(from: int) -> void:
	focusedPlaceCard = from
	if focusedPlaceCard == -1:
		focusedEnemyCard = -1
		%ArrowPlace.clear_points()
func make_focused_enemy(from: int) -> void:
	focusedEnemyCard = from
	
	if focusedPlaceCard != -1 :
		%ArrowPlace.add_point(Vector2(232, 288) + Vector2(SLOT_POSITIONS[focusedPlaceCard], 8) + Vector2(60, 90))
		if focusedEnemyCard == 5:
			%ArrowPlace.add_point(Vector2(232 + 296 + 60,80 - 96 + 32))
		elif focusedEnemyCard != -1:
			%ArrowPlace.add_point(Vector2(232, 80) + Vector2(%EnemyPlace.SLOT_POSITIONS[focusedEnemyCard], 8) + Vector2(60, 90))
		else :
			%ArrowPlace.clear_points()
	else:
		%ArrowPlace.clear_points()
		
@rpc("any_peer")
func make_attack_rpc(placeCard:int , enemyCard:int) -> void:
		var tempEnemyAttack: int = %EnemyPlace.cardSlots[enemyCard].currentAttack
		%EnemyPlace.cardSlots[enemyCard].get_damaged(cardSlots[placeCard].currentAttack, false, enemyCard)
		cardSlots[placeCard].get_damaged(tempEnemyAttack, true, placeCard)


func make_attack() -> void:
	if (focusedPlaceCard != -1 and
		focusedEnemyCard == 5 and
		Global.yourTurn and
		!cardSlots[focusedPlaceCard].asleep and 
		%EnemyPlace.cardSlots[focusedPlaceCard] == null and 
		!%ChoiceNode.choosing):
		cardSlots[focusedPlaceCard].asleep = true
		cardSlots[focusedPlaceCard].whenAttack(focusedEnemyCard)
		%EnemyPlace.update_enemy_life(-cardSlots[focusedPlaceCard].currentAttack)
		multiplayer.rpc(Global.peerID, %YourHand, "update_your_life", [-cardSlots[focusedPlaceCard].currentAttack])
			
	elif (focusedPlaceCard != -1 and
		focusedEnemyCard != -1 and
		focusedEnemyCard != 5 and
		Global.yourTurn and
		!cardSlots[focusedPlaceCard].asleep and 
		!%ChoiceNode.choosing) :
		cardSlots[focusedPlaceCard].asleep = true
		cardSlots[focusedPlaceCard].whenAttack(focusedEnemyCard)
		var tempEnemyAttack: int = %EnemyPlace.cardSlots[focusedEnemyCard].currentAttack
		%EnemyPlace.cardSlots[focusedEnemyCard].get_damaged(cardSlots[focusedPlaceCard].currentAttack, false, focusedEnemyCard)
		cardSlots[focusedPlaceCard].get_damaged(tempEnemyAttack, true, focusedPlaceCard)
		multiplayer.rpc(Global.peerID, %YourPlace, "make_attack_rpc", [focusedEnemyCard, focusedPlaceCard])
		#Disconecting before removing?
		#cardSlots[focusedPlaceCard].disconnect("button_down", make_focused.bind(focusedPlaceCard))
		#cardSlots[focusedPlaceCard].disconnect("button_up", make_attack)
			
	make_focused(-1)
