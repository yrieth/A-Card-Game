extends Control

@onready var choosing: bool = false

signal ally_chosen(slot: int)
signal enemy_chosen(slot: int)

func _ready() -> void:
	var chooseEnemy: Control = get_child(0)
	var chooseAlly: Control = get_child(1)
	var tempChildren: Array[Node] = chooseEnemy.get_children()
	for i in range(0,6):
		tempChildren[i].connect("pressed", enemy_signal_resender.bind(i))
	tempChildren = chooseAlly.get_children()
	for i in range(0,6):
		tempChildren[i].connect("pressed", ally_signal_resender.bind(i))

func enemy_signal_resender(slot: int) ->void:
	emit_signal("enemy_chosen", slot)
func ally_signal_resender(slot: int)->void:
	emit_signal("ally_chosen", slot)

func choose_enemy(includeHero: bool) -> int:
	if !includeHero:
		var noTarget: bool = true
		var i: int = 0
		while noTarget and i < 5:
			if %EnemyPlace.cardSlots[i] != null:
				noTarget = false
			i+=1
		if noTarget:
			return -1
	choosing = true
	var chooseEnemy: Control = get_child(0)
	var tempChildren: Array[Node] = chooseEnemy.get_children()
	for i in range(0,5):
		if %EnemyPlace.cardSlots[i] == null:
			tempChildren[i].disabled = true
		else:
			tempChildren[i].disabled = false
	tempChildren[5].disabled = !includeHero
	self.visible = true
	chooseEnemy.visible = true
	var result: int =  await enemy_chosen
	chooseEnemy.visible = false
	self.visible = false
	choosing = false
	return result

func choose_ally(includeHero: bool) -> int:
	if !includeHero:
		var noTarget: bool = true
		var i: int = 0
		while noTarget and i < 5:
			if %YourPlace.cardSlots[i] != null:
				noTarget = false
			i+=1
		if noTarget:
			return -1
	choosing = true
	var chooseAlly: Control = get_child(1)
	var tempChildren: Array[Node] = chooseAlly.get_children()
	for i in range(0,5):
		if %YourPlace.cardSlots[i] == null:
			tempChildren[i].disabled = true
		else:
			tempChildren[i].disabled = false
	tempChildren[5].disabled = !includeHero
	self.visible = true
	chooseAlly.visible = true
	var result: int =  await ally_chosen
	chooseAlly.visible = false
	self.visible = false
	choosing = false
	return result
