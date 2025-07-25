extends Button



func _on_pressed() -> void:
	var collection: Control = get_parent()
	collection.visible = false
	%MainMenu.visible = true
	Global.deckToPlay = collection.decks[collection.selectedDeck].deck
	
	var decksFile: FileAccess = FileAccess.open("res://saves/decks.save", FileAccess.WRITE)
	for deck in collection.decks:
		decksFile.store_line(deck.name)
		decksFile.store_line(str(deck.deck))
	decksFile.close()
	
	
