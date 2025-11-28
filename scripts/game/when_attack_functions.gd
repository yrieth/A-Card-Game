extends Node

func whenAttackFuriousUrsa(card: Card, target: int) -> void:
	var this: int = %YourPlace.cardSlots.find(card)
	card.change_current_attack(1)
	multiplayer.rpc(Global.peerID, get_parent(), "card_methods_rpc", ["change_current_attack", 1, false, this])
func whenAttackHealingStatue(card: Card, target: int)->void:
	if target == 5:
		%EnemyPlace.update_enemy_life(2*card.currentAttack)
		multiplayer.rpc(Global.peerID, %YourHand, "update_your_life", [2*card.currentAttack])
	else :
		%EnemyPlace.cardSlots[target].get_damaged(-2*card.currentAttack)
		multiplayer.rpc(Global.peerID, get_parent(), "card_methods_rpc", ["get_damaged", -2*card.currentAttack, true, target])
func whenAttackVengefulWasp(card: Card, target: int)->void:
	%EnemyPlace.update_enemy_life(-card.currentAttack)
	multiplayer.rpc(Global.peerID, %YourHand, "update_your_life", [-card.currentAttack])
	
