extends Node

func whenAttackFuriousUrsa(card: Card)->void:
	var target: int = %YourPlace.cardSlots.find(card)
	card.change_current_attack(1)
	multiplayer.rpc(Global.peerID, get_parent(), "card_methods_rpc", ["change_current_attack", 1, false, target])
