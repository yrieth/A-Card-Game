extends Control

class Page extends Control:
	var cards: Array[Card]
	
	#func adopt_cards() -> void:
		#for card:Card in self.cards:
			#self.add_child(card)
class Deck:
	var name: String
	var deck: Array[int]

const SLOTPOSITIONS: Array[Vector2] = [
	Vector2(64.0, 64.0),
	Vector2(64.0, 256.0),
	Vector2(64.0, 448.0),
	Vector2(192.0, 64.0),
	Vector2(192.0, 256.0),
	Vector2(192.0, 448.0),
	Vector2(320.0, 64.0),
	Vector2(320.0, 256.0),
	Vector2(320.0, 448.0),
	Vector2(448.0, 64.0),
	Vector2(448.0, 256.0),
	Vector2(448.0, 448.0),
	Vector2(576.0, 64.0),
	Vector2(576.0, 256.0),
	Vector2(576.0, 448.0),
	Vector2(704.0, 64.0),
	Vector2(704.0, 256.0),
	Vector2(704.0, 448.0),
	Vector2(832.0, 64.0),
	Vector2(832.0, 256.0),
	Vector2(832.0, 448.0)
]

@onready var selectedDeck: int = -1
@onready var currentPage:int = 0
@onready var maxPages:int = 0
var pages:Array[Page]
var decks:Array[Deck]
var unlockedCards: Dictionary[String, bool]

func _ready() -> void:
	var unlockedCardsFile: FileAccess = FileAccess.open("res://saves/unlockedCards.save", FileAccess.READ)
	if unlockedCardsFile == null:
		unlockedCardsFile = FileAccess.open("res://saves/unlockedCards.save", FileAccess.WRITE)
		for i in Global.COLLECTION:
			unlockedCards.get_or_add(i.Name, false)
		unlockedCardsFile.store_var(unlockedCards)
		unlockedCardsFile.close()
		unlockedCardsFile = FileAccess.open("res://saves/unlockedCards.save", FileAccess.READ)
	unlockedCards = unlockedCardsFile.get_var()
	unlockedCardsFile.close()
	if len(unlockedCards) < len(Global.COLLECTION):
		for i in Global.COLLECTION:
			unlockedCards.get_or_add(i.Name, false)
		unlockedCardsFile = FileAccess.open("res://saves/unlockedCards.save", FileAccess.WRITE)
		unlockedCardsFile.store_var(unlockedCards)
		unlockedCardsFile.close()
	elif len(unlockedCards) > len(Global.COLLECTION):
		var tempNamesArray: Array[String]
		for i in Global.COLLECTION:
			tempNamesArray.append(i.Name)
		for i in unlockedCards:
			if i not in tempNamesArray:
				unlockedCards.erase(i)
		unlockedCardsFile = FileAccess.open("res://saves/unlockedCards.save", FileAccess.WRITE)
		unlockedCardsFile.store_var(unlockedCards)
		unlockedCardsFile.close()
	
	
	
	var numCardsToDisplay:int = len(Global.COLLECTION)
	var numCardsDisplayed: int = 0
	var numCardsOnPage: int = 15
	var card:Card
	
	
	
	while numCardsDisplayed < numCardsToDisplay:
		if numCardsOnPage == 15:
			pages.append(Page.new())
			pages[maxPages].visible = false
			add_child(pages[maxPages])
			numCardsOnPage = 0
			maxPages += 1
		else :
			card=Card.new()
			card.get_values(numCardsDisplayed)
			card.position = SLOTPOSITIONS[numCardsOnPage]
			card.disabled = !unlockedCards.get(card.cardName)
			card.connect("pressed", add_card_to_deck.bind(card.cardId))
			pages[maxPages-1].cards.append(card)
			pages[maxPages-1].add_child(card)
			numCardsOnPage+=1
			numCardsDisplayed+=1
	pages[currentPage].visible = true
	
	var decksFile: FileAccess = FileAccess.open("res://saves/decks.save", FileAccess.READ)
	if decksFile != null:
		var tempDeck: Deck
		while decksFile.get_position() < decksFile.get_length():
			tempDeck = Deck.new()
			tempDeck.name = decksFile.get_line()
			tempDeck.deck = line_into_array(decksFile.get_line())
			decks.append(tempDeck)
		
		var counter = 0
		for i:Deck in decks:
			$Decks.add_item(i.name)
			$Decks.set_item_tooltip_enabled(counter, false)
			counter += 1
		decksFile.close()
	
	if decks == []:
		for i in range(0,20):
			Global.deckToPlay.append(i)
	else:
		Global.deckToPlay = decks[0].deck
		

func line_into_array(string: String) -> Array[int]:
	var numberArray:Array[int]
	var bufferNumber: int = 0
	if string == "[]":
		numberArray = []
	else:
		for c in string:
			if "0" <= c and c <= "9":
				bufferNumber = bufferNumber * 10 + int(c)
			elif c == "," or c == "]":
				numberArray.append(bufferNumber)
				bufferNumber = 0
	return numberArray


func _on_button_prev_page_pressed() -> void:
	if currentPage > 1:
		pages[currentPage].visible = false
		currentPage -= 1
		pages[currentPage].visible = true
	elif currentPage == 1:
		pages[currentPage].visible = false
		currentPage -= 1
		pages[currentPage].visible = true
		$ButtonPrevPage.disabled = true
	$ButtonNextPage.disabled = false
func _on_button_next_page_pressed() -> void:
	if currentPage < maxPages - 2:
		pages[currentPage].visible = false
		currentPage += 1
		pages[currentPage].visible = true
	elif currentPage == maxPages - 2:
		pages[currentPage].visible = false
		currentPage += 1
		pages[currentPage].visible = true
		$ButtonNextPage.disabled = true
	$ButtonPrevPage.disabled = false


func _on_decks_item_selected(index: int) -> void:
	if selectedDeck == index:
		$Decks.deselect(index)
		$SelectedDeck.clear()
		selectedDeck = -1
	else: 
		if selectedDeck != -1:
			$SelectedDeck.clear()
		selectedDeck = index
		var tempIndex: int
		for i:int in decks[selectedDeck].deck:
			tempIndex = $SelectedDeck.add_item(Global.COLLECTION[i].Name)
			$SelectedDeck.set_item_tooltip(tempIndex, str(i))
			match Global.COLLECTION[i].Rarity:
				"s":
					$SelectedDeck.set_item_icon(tempIndex, load("res://sprites/StarterRarity.png"))
				"b":
					$SelectedDeck.set_item_icon(tempIndex, load("res://sprites/BlazingRarity.png"))
				"n":
					$SelectedDeck.set_item_icon(tempIndex, load("res://sprites/NioticRarity.png"))
				"S":
					$SelectedDeck.set_item_icon(tempIndex, load("res://sprites/SpiritedRarity.png"))
				"N":
					$SelectedDeck.set_item_icon(tempIndex, load("res://sprites/NitroRarity.png"))
		print(decks[selectedDeck].deck)

func _on_decks_item_activated(index: int) -> void:
	var tempLine: LineEdit = LineEdit.new()
	$Decks.add_child(tempLine)
	tempLine.theme = load("res://misc/ThemeMain.tres")
	tempLine.position = $Decks.get_item_rect(index).position
	tempLine.size = $Decks.get_item_rect(index).size
	tempLine.placeholder_text = $Decks.get_item_text(index)
	tempLine.connect("editing_toggled", rename_deck.bind(tempLine, index))
	tempLine.edit()

func rename_deck(toggled_on:bool, tempLine: LineEdit, index:int) -> void:
	if !toggled_on:
		if tempLine.text != "":
			$Decks.set_item_text(index, tempLine.text)
			decks[index].name = tempLine.text
		$Decks.remove_child(tempLine)
		tempLine.queue_free()

func _on_new_deck_pressed() -> void:
	$Decks.add_item("New Deck")
	$Decks.set_item_tooltip_enabled(len(decks), false)
	decks.append(Deck.new())
	decks[len(decks)-1].name = "New Deck"

func _on_remove_deck_pressed() -> void:
	if selectedDeck != -1:
		$Decks.remove_item(selectedDeck)
		$SelectedDeck.clear()
		decks.remove_at(selectedDeck)

func add_card_to_deck(id:int) -> void:
	if selectedDeck != -1 and !decks[selectedDeck].deck.has(id) and len(decks[selectedDeck].deck) < 20:
		var index: int = $SelectedDeck.add_item(Global.COLLECTION[id].Name)
		$SelectedDeck.set_item_tooltip(index, str(id))
		match Global.COLLECTION[id].Rarity:
			"s":
				$SelectedDeck.set_item_icon(index, load("res://sprites/StarterRarity.png"))
			"b":
				$SelectedDeck.set_item_icon(index, load("res://sprites/BlazingRarity.png"))
			"n":
				$SelectedDeck.set_item_icon(index, load("res://sprites/NioticRarity.png"))
			"S":
				$SelectedDeck.set_item_icon(index, load("res://sprites/SpiritedRarity.png"))
			"N":
				$SelectedDeck.set_item_icon(index, load("res://sprites/NitroRarity.png"))
		decks[selectedDeck].deck.append(id)

func remove_card_from_deck(index:int, _at_position: Vector2, mouse_button_index: int) -> void:
	if mouse_button_index == 2:
		decks[selectedDeck].deck.erase(int($SelectedDeck.get_item_tooltip(index)))
		$SelectedDeck.remove_item(index)

func _on_start_unlocker_pressed() -> void:
	for i in Global.COLLECTION:
		if i.Rarity == "s":
			unlockedCards.set(i.Name, true)
	$StartUnlocker.disabled = true
