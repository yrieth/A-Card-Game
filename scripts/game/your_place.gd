extends Control

const SLOT_POSITIONS: Array[int] = [8, 8+24+120, 8+2*24+120*2, 8+3*24+120*3, 8+4*24+120*4]
@onready var cardSlots: Array[Card] = [null, null, null, null, null]


func put_card(slot:int) -> void:
	if  %YourHand.focusedCard != -1 and cardSlots[slot] == null:
		var card = %YourHand.cardSlots[%YourHand.focusedCard]
		cardSlots[slot] = card
		%YourHand.remove_focused()
		self.add_child(card)
		card.position = Vector2(SLOT_POSITIONS[slot], 8)
		multiplayer.rpc(Global.peerID, %EnemyPlace, "put_card", [card.cardId,slot])

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
