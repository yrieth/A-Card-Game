extends Control

const SlotPositions: Array[int] = [24, 2*24+120, 3*24+120*2, 4*24+120*3, 5*24+120*4, 6*24+120*5, 7*24+120*6]
const MaxCards = 7
var cardSlots: Array[Card]
var focusedCard:int
@onready var numCards: int = 0

func get_card() -> void:
	if numCards < MaxCards:
		#card:Card = deck.get_card()
		var card:Card = Card.new()
		Card.getValues(card, 1)
		card.position = Vector2(SlotPositions[numCards], 0)
		self.add_child(card)
		cardSlots.append(card)
		numCards+=1
	else:
		print("Too many cards")

func _on_button_pressed() -> void:
	get_card()
