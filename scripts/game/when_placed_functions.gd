extends Node

func whenPlacedSomething() -> void:
	get_parent().maxGold += 1
	%YourHand.update_gold()
