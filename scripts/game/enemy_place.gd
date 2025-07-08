extends Control

const SLOT_POSITIONS: Array[int] = [8, 8+24+120, 8+2*24+120*2, 8+3*24+120*3, 8+4*24+120*4]
@onready var cardSlots: Array[Card] = [null, null, null, null, null]

@rpc("any_peer")
func put_card(cardId: int ,slot:int) -> void:
	var card = Card.new()
	card.getValues(cardId)
	cardSlots[slot] = card
	self.add_child(card)
	card.position = Vector2(SLOT_POSITIONS[slot], 8)
