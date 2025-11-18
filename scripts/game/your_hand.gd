extends Control

const SLOT_POSITIONS: Array[int] = [24, 2*24+120, 3*24+120*2, 4*24+120*3, 5*24+120*4, 6*24+120*5, 7*24+120*6]
const MAX_CARDS = 7
@onready var fatigue: int = 1
@onready var cardSlots: Array[Card] = [null, null, null, null, null, null, null]
@onready var focusedHandCard: int = -1
@onready var focusedPlaceSlot: int = -1
@onready var numCards: int = 0
@onready var yourLife: int = 25

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
	$LifeDisplay.get_child(0).text = str(yourLife)
	$LifeDisplay.value = yourLife

@rpc("any_peer")
func draw_card() -> void:
	if get_parent().deckToPlay.is_empty():
		var fatigueTween: Tween = create_tween()
		var fatigueDisplay: Label = Label.new()
		fatigueDisplay.scale = Vector2(3.0, 3.0)
		fatigueDisplay.size = Vector2(171, 21)
		fatigueDisplay.position = Vector2(-512.0, -448.0)
		fatigueDisplay.label_settings = load("res://misc/LabelSettingsFatigue.tres")
		fatigueDisplay.text = "Fatigue: " + str(fatigue)
		self.add_child(fatigueDisplay)
		fatigueTween.tween_property(fatigueDisplay, "position", Vector2(1280.0, -448.0), 3)
		fatigueTween.tween_callback(fatigueDisplay.queue_free)
		update_your_life(-fatigue)
		multiplayer.rpc(Global.peerID, %EnemyPlace, "update_enemy_life", [-fatigue])
		fatigue += 1
	elif numCards < MAX_CARDS:
		var card:Card = Card.new()
		var tempCardId: int = get_parent().deckToPlay.pop_back()
		var cardTween: Tween = create_tween()
		cardTween.set_trans(Tween.TRANS_CUBIC)
		card.get_values(tempCardId)
		tempCardId = Global.deckToPlay.find(tempCardId)
		$ShowDeck.get_popup().remove_item(tempCardId)
		Global.deckToPlay.remove_at(tempCardId)
		cardTween.tween_property(card, "position", Vector2(SLOT_POSITIONS[numCards], 0), 0.5)
		self.add_child(card)
		cardSlots[numCards] = card
		card.connect("button_down",make_focused.bind(numCards))
		card.connect("button_up",make_move)
		numCards+=1
	elif numCards >= MAX_CARDS:
		var tempCardId: int = Global.deckToPlay.find(get_parent().deckToPlay.pop_back())
		$ShowDeck.get_popup().remove_item(tempCardId)
		Global.deckToPlay.remove_at(tempCardId)
	

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
		cardSlots[focusedHandCard].cost <= get_parent().gold and 
		!%ChoiceNode.choosing):
			%YourPlace.put_card(cardSlots[focusedHandCard], focusedPlaceSlot)
	make_focused(-1)

func remove_focused() -> void:
	var cardTween: Tween
	if focusedHandCard != numCards-1:
		cardTween = create_tween()
		cardTween.set_trans(Tween.TRANS_CUBIC)
	cardSlots[focusedHandCard].disconnect("button_down", make_focused.bind(focusedHandCard))
	cardSlots[focusedHandCard].disconnect("button_up", make_move)
	self.remove_child(cardSlots[focusedHandCard])
	numCards-=1

	for i in range(focusedHandCard, numCards):
		cardSlots[i] = cardSlots[i+1]
		cardSlots[i].disconnect("button_down", make_focused.bind(i+1))
		cardSlots[i].connect("button_down",make_focused.bind(i))
		cardTween.tween_property(cardSlots[i], "position", Vector2(SLOT_POSITIONS[i], 0), 0.5)
	cardSlots[numCards] = null

func update_gold() -> void:
	var goldTween: Tween = create_tween()
	goldTween.set_trans(Tween.TRANS_CUBIC)
	goldTween.tween_property($GoldDisplay, "value", get_parent().gold, 1)
	#$GoldDisplay.value = get_parent().gold
	$GoldDisplay.get_child(0).text=str(get_parent().gold) + "/" + str(get_parent().maxGold)

@rpc("any_peer")
func update_your_life(amount: int) -> void:
	
	yourLife += amount
	var lifeTween: Tween = create_tween()
	lifeTween.set_trans(Tween.TRANS_CUBIC)
	lifeTween.tween_property($LifeDisplay, "value", yourLife, 1)
	$LifeDisplay.get_child(0).text = str(yourLife)
	#$LifeDisplay.value = yourLife
	if yourLife < 1:
		var buttonTween: Tween = create_tween()
		buttonTween.tween_property(%YouLoseButton, "visible", true, 0)
		buttonTween.tween_property(%YouLoseButton, "modulate", Color(1,1,1,1), 3)
		buttonTween.tween_property(%YouLoseButton, "disabled", false, 0)
