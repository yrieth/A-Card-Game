extends Control

const SLOT_POSITIONS: Array[int] = [8, 8+24+120, 8+2*24+120*2, 8+3*24+120*3, 8+4*24+120*4]
@onready var cardSlots: Array[Card] = [null, null, null, null, null]
@onready var focusedPlaceCard: int = -1
@onready var focusedEnemyCard: int = -1


func put_card(slot:int, card:Card) -> void:
	var cardTween: Tween = create_tween()
	cardTween.set_trans(Tween.TRANS_CUBIC)
	cardSlots[slot] = card
	get_parent().gold -= card.cost
	%YourHand.update_gold()
	%YourHand.remove_focused()
	self.add_child(card)
	card.position += Vector2(-232, -288+512)
	cardTween.tween_property(card, "position", Vector2(SLOT_POSITIONS[slot], 8), 0.5)
	card.whenPlaced()
	multiplayer.rpc(Global.peerID, %EnemyPlace, "put_card", [card.cardId,slot])
	
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
func make_attack_rpc(focusedPlaceCard:int , focusedEnemyCard:int) -> void:
		%EnemyPlace.cardSlots[focusedEnemyCard].get_damaged(cardSlots[focusedPlaceCard].currentAttack)
		cardSlots[focusedPlaceCard].get_damaged(%EnemyPlace.cardSlots[focusedEnemyCard].currentAttack)
		if cardSlots[focusedPlaceCard].currentLife < 1:
			cardSlots[focusedPlaceCard].disconnect("button_down", make_focused.bind(focusedPlaceCard))
			cardSlots[focusedPlaceCard].disconnect("button_up", make_attack)
			#cardSlots[focusedPlaceCard].whenDies() #TODO
			cardSlots[focusedPlaceCard].queue_free()
			cardSlots[focusedPlaceCard] = null
		if %EnemyPlace.cardSlots[focusedEnemyCard].currentLife < 1:
			%EnemyPlace.cardSlots[focusedEnemyCard].disconnect("mouse_entered", %YourPlace.make_focused_enemy.bind(focusedEnemyCard))
			%EnemyPlace.cardSlots[focusedEnemyCard].disconnect("mouse_exited", %YourPlace.make_focused_enemy.bind(-1))
			#cardSlots[focusedPlaceCard].whenDies()
			%EnemyPlace.cardSlots[focusedEnemyCard].queue_free()
			%EnemyPlace.cardSlots[focusedEnemyCard] = null

func make_attack() -> void:
	if (focusedPlaceCard != -1 and
		focusedEnemyCard == 5 and
		Global.yourTurn and
		!cardSlots[focusedPlaceCard].asleep and 
		%EnemyPlace.cardSlots[focusedPlaceCard] == null):
		%EnemyPlace.update_enemy_life(-cardSlots[focusedPlaceCard].currentAttack)
		multiplayer.rpc(Global.peerID, %YourHand, "update_your_life", [-cardSlots[focusedPlaceCard].currentAttack])
		cardSlots[focusedPlaceCard].asleep = true
			
	elif (focusedPlaceCard != -1 and
		focusedEnemyCard != -1 and
		focusedEnemyCard != 5 and
		Global.yourTurn and
		!cardSlots[focusedPlaceCard].asleep) :
		cardSlots[focusedPlaceCard].whenAttack()
		%EnemyPlace.cardSlots[focusedEnemyCard].get_damaged(cardSlots[focusedPlaceCard].currentAttack)
		cardSlots[focusedPlaceCard].get_damaged(%EnemyPlace.cardSlots[focusedEnemyCard].currentAttack)
		multiplayer.rpc(Global.peerID, %YourPlace, "make_attack_rpc", [focusedEnemyCard, focusedPlaceCard])
		cardSlots[focusedPlaceCard].asleep = true
		
		
		if cardSlots[focusedPlaceCard].currentLife < 1:
			cardSlots[focusedPlaceCard].disconnect("button_down", make_focused.bind(focusedPlaceCard))
			cardSlots[focusedPlaceCard].disconnect("button_up", make_attack)
			#cardSlots[focusedPlaceCard].whenDies()
			cardSlots[focusedPlaceCard].queue_free()
			cardSlots[focusedPlaceCard] = null
		if %EnemyPlace.cardSlots[focusedEnemyCard].currentLife < 1:
			%EnemyPlace.cardSlots[focusedEnemyCard].disconnect("mouse_entered", %YourPlace.make_focused_enemy.bind(focusedEnemyCard))
			%EnemyPlace.cardSlots[focusedEnemyCard].disconnect("mouse_exited", %YourPlace.make_focused_enemy.bind(-1))
			#cardSlots[focusedPlaceCard].whenDies()
			%EnemyPlace.cardSlots[focusedEnemyCard].queue_free()
			%EnemyPlace.cardSlots[focusedEnemyCard] = null
			
	make_focused(-1)
