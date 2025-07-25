extends Button



func _on_pressed() -> void:
	var collection: Control = get_parent()
	collection.visible = false
	%MainMenu.visible = true
	
	var decksFile: FileAccess = FileAccess.open("res://saves/decks.save", FileAccess.WRITE)
	for deck in collection.decks:
		decksFile.store_line(deck.name)
		decksFile.store_var(deck.deck)
	decksFile.close()
	
