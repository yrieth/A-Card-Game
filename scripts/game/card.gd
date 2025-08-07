extends TextureButton
class_name Card

static var whenPlacedFunctions: Node
static var whenAttackFunctions: Node
static var whenDiesFunctions: Node

var cardId: int
var life: int
var currentLife: int
var maxLife: int
var displayLife: Label
var attack: int
var currentAttack: int
var displayAttack: Label
var cost: int
var currentCost: int
var displayCost: Label
var cardName: String
var cardDesc: String
var rarity: String

var whenPlacedFunc: String
var whenAttackFunc: String
var whenDiesFunc: String

var asleep: bool

func get_values(id:int) -> void:
	var dict = Global.COLLECTION[id]
	self.cardId = id
	self.life = dict.Life
	self.attack = dict.Attack
	self.cost = dict.Cost
	self.cardName = dict.Name
	self.cardDesc = dict.Description
	self.whenPlacedFunc = dict.whenPlacedFunc
	self.whenAttackFunc = dict.whenAttackFunc
	self.whenDiesFunc = dict.whenDiesFunc
	self.rarity = dict.Rarity
	self.asleep = true

func makeLife() -> Label:
	var tempLabel:Label = Label.new()
	tempLabel.label_settings = load("res://misc/LabelSettingMain.tres")
	tempLabel.size = Vector2(12, 18)
	tempLabel.position = Vector2(103, 156)
	tempLabel.text = str(currentLife)
	tempLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	self.add_child(tempLabel)
	return tempLabel

func makeAttack() -> Label:
	var tempLabel:Label = Label.new()
	tempLabel.label_settings = load("res://misc/LabelSettingMain.tres")
	tempLabel.size = Vector2(12, 18)
	tempLabel.position = Vector2(7, 156)
	tempLabel.text = str(currentAttack)
	tempLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	self.add_child(tempLabel)
	return tempLabel
	
func makeCost() -> Label:
	var tempLabel:Label = Label.new()
	tempLabel.label_settings = load("res://misc/LabelSettingMain.tres")
	tempLabel.size = Vector2(12, 18)
	tempLabel.position = Vector2(103, 6)
	tempLabel.text = str(currentCost)
	tempLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	self.add_child(tempLabel)
	return tempLabel

func makeName() -> void:
	var tempLabel:Label = Label.new()
	tempLabel.label_settings = load("res://misc/LabelSettingMain.tres")
	tempLabel.scale = Vector2(0.8, 0.8)
	tempLabel.size = Vector2(130, 20)
	tempLabel.position = Vector2(8, 72)
	tempLabel.text = cardName
	tempLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	tempLabel.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	self.add_child(tempLabel)

func makeRarity() -> void:
	var tempTexture: TextureRect = TextureRect.new()
	self.add_child(tempTexture)
	tempTexture.position = Vector2(6,6)
	tempTexture.size = Vector2(15,15)
	match rarity:
		"s":
			tempTexture.texture = load("res://sprites/StarterRarity.png")
		"b":
			tempTexture.texture = load("res://sprites/BlazingRarity.png")
		"n":
			tempTexture.texture = load("res://sprites/NioticRarity.png")
		"S":
			tempTexture.texture = load("res://sprites/SpiritedRarity.png")
		"N":
			tempTexture.texture = load("res://sprites/NitroRarity.png")
	

func _ready() -> void:
	self.stretch_mode = TextureButton.STRETCH_SCALE
	self.texture_normal = load("res://sprites/CardTemplate.png")
	self.texture_disabled = load("res://sprites/CardTemplateDisabled.png")
	self.size = Vector2(120, 180)
	self.modulate = Color(1,1,1)
	self.pivot_offset = Vector2(60, 90)
	
	connect("mouse_entered", _on_mouse_entered)
	connect("mouse_exited", _on_mouse_exited)
	
	currentLife = life
	maxLife = life
	currentAttack = attack
	currentCost = cost
	
	displayLife = makeLife()
	displayAttack = makeAttack()
	displayCost = makeCost()
	makeName()
	makeRarity()

@rpc("any_peer")
func get_damaged(amount: int)->void:
	self.currentLife -= amount
	self.displayLife.text = str(currentLife)
func whenPlaced() -> void:
	if whenPlacedFunc != "":
		whenPlacedFunctions.call(whenPlacedFunc, self)
func whenAttack() -> void:
	if whenAttackFunc != "":
		whenAttackFunctions.call(whenAttackFunc, self)
func whenDies() -> void:
	if whenDiesFunc != "":
		whenDiesFunctions.call(whenDiesFunc, self)

func _on_mouse_entered() -> void:
	self.modulate = Color(1.2, 1.2, 1.2)
	self.scale = Vector2(1.3,1.3)
	#self.top_level = true
	self.z_index = 1


func _on_mouse_exited() -> void:
	self.modulate = Color(1,1,1)
	self.scale = Vector2(1,1)
	#self.top_level = false
	self.z_index = 0
	
