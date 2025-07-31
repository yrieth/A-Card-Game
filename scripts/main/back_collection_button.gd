extends Button

func _on_pressed() -> void:
	var collection: Control = get_parent()
	collection.visible = false
	%MainMenu.visible = true
	if collection.decks == []:
		for i in range(0,20):
			Global.deckToPlay.append(i)
	else:
		Global.deckToPlay = collection.decks[collection.selectedDeck].deck
	
	
	var decksFile: FileAccess = FileAccess.open("res://saves/decks.save", FileAccess.WRITE)
	for deck in collection.decks:
		decksFile.store_line(deck.name)
		decksFile.store_line(str(deck.deck))
	decksFile.close()
	
	var unlockedCardsFile: FileAccess = FileAccess.open("res://saves/unlockedCards.save", FileAccess.WRITE)
	unlockedCardsFile.store_var(collection.unlockedCards)
	unlockedCardsFile.close()
	
	
	
