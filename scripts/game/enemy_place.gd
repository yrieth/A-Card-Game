extends Control

const SLOT_POSITIONS: Array[int] = [8, 8+24+120, 8+2*24+120*2, 8+3*24+120*3, 8+4*24+120*4]
@onready var cardSlots: Array[Card] = [null, null, null, null, null]
@onready var enemyLife: int = 25

func _ready() -> void:
	$EnemyHero.connect("mouse_entered", %YourPlace.make_focused_enemy.bind(5))
	$EnemyHero.connect("mouse_exited", %YourPlace.make_focused_enemy.bind(-1))
	$EnemyHero.text = str(enemyLife)

@rpc("any_peer")
func put_card(cardId: int ,slot:int) -> void:
	var card = Card.new()
	card.get_values(cardId)
	cardSlots[slot] = card
	self.add_child(card)
	card.position = Vector2(SLOT_POSITIONS[slot], 8-88-180)
	var cardTween: Tween = create_tween()
	cardTween.set_trans(Tween.TRANS_CUBIC)
	cardTween.tween_property(card, "position", Vector2(SLOT_POSITIONS[slot], 8), 0.5)
	
	#Signals
	card.connect("mouse_entered", %YourPlace.make_focused_enemy.bind(slot))
	card.connect("mouse_exited", %YourPlace.make_focused_enemy.bind(-1))

@rpc("any_peer")
func remove_card(slot:int) -> void:
	cardSlots[slot].disconnect("mouse_entered", %YourPlace.make_focused_enemy.bind(slot))
	cardSlots[slot].disconnect("mouse_exited", %YourPlace.make_focused_enemy.bind(-1))
	cardSlots[slot].queue_free()
	cardSlots[slot] = null
	
@rpc("any_peer")
func update_enemy_life(amount: int) -> void:
	enemyLife += amount
	$EnemyHero.text = str(enemyLife)
	if enemyLife < 1:
		var buttonTween: Tween = create_tween()
		buttonTween.tween_property(%YouWinButton, "visible", true, 0)
		buttonTween.tween_property(%YouWinButton, "modulate", Color(1,1,1,1), 3)
		buttonTween.tween_property(%YouWinButton, "disabled", false, 0)
