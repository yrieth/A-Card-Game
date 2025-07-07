extends Control

const SlotPositions: Array[int] = [24, 2*24+120, 3*24+120*2, 4*24+120*3, 5*24+120*4, 6*24+120*5, 7*24+120*6]
const MaxCards = 7
@onready var cardSlots: Array[Card] = [null, null, null, null, null, null, null]
@onready var focusedCard: int = -1
@onready var numCards: int = 0

func get_card() -> void:
	if numCards < MaxCards:
		#card:Card = deck.get_card()
		var card:Card = Card.new()
		Card.getValues(card, 1)
		card.position = Vector2(SlotPositions[numCards], 0)
		self.add_child(card)
		cardSlots[numCards] = card
		card.connect("pressed",make_focused.bind(numCards))
		numCards+=1
	else:
		print("Too many cards")

func make_focused(from: int) -> void:
	if from == focusedCard:
		focusedCard = -1
	else :
		focusedCard = from
	update_focused_text(focusedCard)
	
func update_focused_text(focused: int) -> void:
	$Label.text = "Focused: %d" % focused

func remove_focused() -> void:
	cardSlots[focusedCard].disconnect("pressed", make_focused.bind(focusedCard))
	self.remove_child(cardSlots[focusedCard])
	numCards-=1
	for i in range(focusedCard, numCards):
		cardSlots[i] = cardSlots[i+1]
		cardSlots[i].disconnect("pressed", make_focused.bind(i+1))
		cardSlots[i].connect("pressed",make_focused.bind(i))
		cardSlots[i].position = Vector2(SlotPositions[i], 0)
	cardSlots[numCards] = null
	focusedCard = -1
	update_focused_text(-1)

func _on_button_pressed() -> void:
	get_card()
