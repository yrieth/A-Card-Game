extends Node

func whenPlacedSomething(card:Card) -> void:
	get_parent().maxGold += 1
	%YourHand.update_gold()
