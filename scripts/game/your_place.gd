extends Control

const SLOT_POSITIONS: Array[int] = [8, 8+24+120, 8+2*24+120*2, 8+3*24+120*3, 8+4*24+120*4]
@onready var cardSlots: Array[Card] = [null, null, null, null, null]
@onready var focusedPlaceCard: int = -1
@onready var focusedEnemyCard: int = -1

func put_card(slot:int) -> void:
	if  can_play_card(slot):
		var card: Card = %YourHand.cardSlots[%YourHand.focusedHandCard]
		cardSlots[slot] = card
		get_parent().gold -= card.cost
		%YourHand.update_gold()
		%YourHand.remove_focused()
		self.add_child(card)
		card.position = Vector2(SLOT_POSITIONS[slot], 8)
		card.whenPlaced()
		multiplayer.rpc(Global.peerID, %EnemyPlace, "put_card", [card.cardId,slot])
		
		#Signals
		card.connect("button_down", make_focused.bind(slot))
		card.connect("button_up", make_attack)

func can_play_card(slot: int) -> bool:
	return (
	%YourHand.focusedHandCard != -1 and
	cardSlots[slot] == null and
	Global.yourTurn and
	%YourHand.cardSlots[%YourHand.focusedHandCard].cost <= get_parent().gold
	)

func make_focused(from: int) -> void:
	focusedPlaceCard = from
	if focusedPlaceCard == -1:
		focusedEnemyCard = -1
		%Arrow.clear_points()
func make_focused_enemy(from: int) -> void:
	focusedEnemyCard = from
	if focusedPlaceCard != -1 and focusedEnemyCard != -1:
		%Arrow.add_point(Vector2(232, 288) + Vector2(SLOT_POSITIONS[focusedPlaceCard], 8) + Vector2(60, 90))
		%Arrow.add_point(Vector2(232, 80) + Vector2(%EnemyPlace.SLOT_POSITIONS[focusedEnemyCard], 8) + Vector2(60, 90))
	else:
		%Arrow.clear_points()
func make_attack() -> void:
	print(%Arrow.points)
	if focusedPlaceCard != -1 and focusedEnemyCard != -1:
		cardSlots[focusedPlaceCard].whenAttack()
		%EnemyPlace.cardSlots[focusedEnemyCard].get_damaged(cardSlots[focusedPlaceCard].currentAttack)
	make_focused(-1)
func _on_your_slot_0_pressed() -> void:
	put_card(0)

func _on_your_slot_1_pressed() -> void:
	put_card(1)

func _on_your_slot_2_pressed() -> void:
	put_card(2)

func _on_your_slot_3_pressed() -> void:
	put_card(3)

func _on_your_slot_4_pressed() -> void:
	put_card(4)
