extends Control

const SLOT_POSITIONS: Array[int] = [24, 2*24+120, 3*24+120*2, 4*24+120*3, 5*24+120*4, 6*24+120*5, 7*24+120*6]
const MAX_CARDS = 7
@onready var fatigue: int = 1
@onready var cardSlots: Array[Card] = [null, null, null, null, null, null, null]
@onready var focusedHandCard: int = -1
@onready var focusedPlaceSlot: int = -1
@onready var numCards: int = 0

func _ready() -> void:
	var popup:PopupMenu = $ShowDeck.get_popup()
	popup.hide_on_item_selection = false
	#Signals
	var tempSlotArray: Array[Node] = %YourPlace.get_children()
	for i in range(0, len(tempSlotArray)):
		tempSlotArray[i].connect("mouse_entered", make_focused_place.bind(i))
		tempSlotArray[i].connect("mouse_exited", make_focused_place.bind(-1))
	for i in Global.deckToPlay:
		$ShowDeck.get_popup().add_item(Global.COLLECTION[i].Name)

func get_card() -> void:
	if numCards < MAX_CARDS and !Global.deckToPlay.is_empty():
		var card:Card = Card.new()
		card.get_values(Global.deckToPlay.pop_back())
		$ShowDeck.get_popup().remove_item(len(Global.deckToPlay))
		card.position = Vector2(SLOT_POSITIONS[numCards], 0)
		self.add_child(card)
		cardSlots[numCards] = card
		card.connect("button_down",make_focused.bind(numCards))
		card.connect("button_up",make_move)
		numCards+=1
	elif numCards >= MAX_CARDS and !Global.deckToPlay.is_empty():
		Global.deckToPlay.pop_back()
		$ShowDeck.get_popup().remove_item(len(Global.deckToPlay))
	elif Global.deckToPlay.is_empty():
		pass #fatigue

func make_focused(from: int) -> void:
	focusedHandCard = from
	if focusedHandCard == -1:
		focusedPlaceSlot = -1
		%ArrowHand.clear_points()
func make_focused_place(from: int) -> void:
	focusedPlaceSlot = from
	if focusedHandCard != -1 and focusedPlaceSlot != -1:
		%ArrowHand.add_point(Vector2(0, 512) + Vector2(SLOT_POSITIONS[focusedHandCard], 0) + Vector2(60, 90))
		%ArrowHand.add_point(Vector2(232, 288) + Vector2(%YourPlace.SLOT_POSITIONS[focusedPlaceSlot], 8) + Vector2(60, 90))
	else:
		%ArrowHand.clear_points()
func make_move() -> void:
	if (focusedHandCard != -1 and
		focusedPlaceSlot != -1 and
		%YourPlace.cardSlots[focusedPlaceSlot] == null and
		Global.yourTurn and
		cardSlots[focusedHandCard].cost <= get_parent().gold):
			%YourPlace.put_card(focusedPlaceSlot, cardSlots[focusedHandCard])
	make_focused(-1)

func remove_focused() -> void:
	cardSlots[focusedHandCard].disconnect("button_down", make_focused.bind(focusedHandCard))
	cardSlots[focusedHandCard].disconnect("button_up", make_move)
	self.remove_child(cardSlots[focusedHandCard])
	numCards-=1
	for i in range(focusedHandCard, numCards):
		cardSlots[i] = cardSlots[i+1]
		cardSlots[i].disconnect("button_down", make_focused.bind(i+1))
		cardSlots[i].connect("button_down",make_focused.bind(i))
		cardSlots[i].position = Vector2(SLOT_POSITIONS[i], 0)
	cardSlots[numCards] = null

func update_gold() -> void:
	$GoldDisplay.text = "Gold: " + str(get_parent().gold) + "/" + str(get_parent().maxGold)
