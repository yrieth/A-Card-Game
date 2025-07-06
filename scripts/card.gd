extends TextureRect
class_name Card

@export var life: int
var currentLife: int
var maxLife: int
var displayLife: Label
@export var attack: int
var currentAttack: int
var displayAttack: Label
@export var cost: int
var currentCost: int
var displayCost: Label
@export var cardName: String
@export var cardDesc: String




func makeLife() -> Label:
	var tempLabel:Label = Label.new()
	tempLabel.label_settings = load("res://LabelSettingMain.tres")
	tempLabel.size = Vector2(12, 9)
	tempLabel.position = Vector2(102, 162)
	tempLabel.text = str(currentLife)
	tempLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	self.add_child(tempLabel)
	return tempLabel

func makeAttack() -> Label:
	var tempLabel:Label = Label.new()
	tempLabel.label_settings = load("res://LabelSettingMain.tres")
	tempLabel.size = Vector2(12, 9)
	tempLabel.position = Vector2(9, 162)
	tempLabel.text = str(currentAttack)
	tempLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	self.add_child(tempLabel)
	return tempLabel
	
func makeCost() -> Label:
	var tempLabel:Label = Label.new()
	tempLabel.label_settings = load("res://LabelSettingMain.tres")
	tempLabel.size = Vector2(12, 9)
	tempLabel.position = Vector2(102, 12)
	tempLabel.text = str(currentCost)
	tempLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	self.add_child(tempLabel)
	return tempLabel

func makeName() -> void:
	var tempLabel:Label = Label.new()
	tempLabel.label_settings = load("res://LabelSettingMain.tres")
	tempLabel.size = Vector2(83, 14)
	tempLabel.position = Vector2(6, 72)
	tempLabel.scale = Vector2(1.3, 1.3)
	tempLabel.text = cardName
	tempLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tempLabel.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	self.add_child(tempLabel)

func _ready() -> void:
	self.texture = load("res://sprites/CardTemplate.png")
	self.size = Vector2(120, 180)
	
	currentLife = life
	maxLife = life
	currentAttack = attack
	currentCost = cost
	
	displayLife = makeLife()
	displayAttack = makeAttack()
	displayCost = makeCost()
	makeName()
