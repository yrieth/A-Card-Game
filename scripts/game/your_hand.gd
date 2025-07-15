extends Control

const SLOT_POSITIONS: Array[int] = [24, 2*24+120, 3*24+120*2, 4*24+120*3, 5*24+120*4, 6*24+120*5, 7*24+120*6]
const MAX_CARDS = 7
@onready var cardSlots: Array[Card] = [null, null, null, null, null, null, null]
@onready var focusedHandCard: int = -1
@onready var numCards: int = 0

func get_card() -> void:
	if numCards < MAX_CARDS:
		#Substitute for deck
		#card:Card = deck.get_card()
		var card:Card = Card.new()
		card.getValues(0)
		card.position = Vector2(SLOT_POSITIONS[numCards], 0)
		self.add_child(card)
		cardSlots[numCards] = card
		card.connect("pressed",make_focused.bind(numCards))
		numCards+=1
	else:
		print("Too many cards")

func make_focused(from: int) -> void:
	if from == focusedHandCard:
		focusedHandCard = -1
	else :
		focusedHandCard = from
	update_focused_text()
	
func update_focused_text() -> void:
	$FocusedDisplay.text = "Focused in hand: %d" % focusedHandCard

func remove_focused() -> void:
	cardSlots[focusedHandCard].disconnect("pressed", make_focused.bind(focusedHandCard))
	self.remove_child(cardSlots[focusedHandCard])
	numCards-=1
	for i in range(focusedHandCard, numCards):
		cardSlots[i] = cardSlots[i+1]
		cardSlots[i].disconnect("pressed", make_focused.bind(i+1))
		cardSlots[i].connect("pressed",make_focused.bind(i))
		cardSlots[i].position = Vector2(SLOT_POSITIONS[i], 0)
	cardSlots[numCards] = null
	focusedHandCard = -1
	update_focused_text()

func update_gold() -> void:
	$GoldDisplay.text = "Gold: " + str(get_parent().gold) + "/" + str(get_parent().maxGold)
