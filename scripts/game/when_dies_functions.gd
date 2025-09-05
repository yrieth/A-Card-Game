extends Node

func whenDiesHealingBeetle(card:Card) -> void:
	%YourHand.update_your_life(2)
	multiplayer.rpc(Global.peerID, %EnemyPlace, "update_enemy_life", [2])

func whenDiesLeoric(card:Card) -> void:
	var slot: int = %YourPlace.cardSlots.find(card)
	await get_tree().create_timer(0.8).timeout
	var fallenLeoric: Card = Card.new()
	fallenLeoric.get_values(Global.FALLENLEORICINDEX)
	%YourPlace.put_card(fallenLeoric, slot, false)
func whenDiesGoldMiner(card: Card) -> void:
	get_parent().maxGold += 1
	%YourHand.update_gold()
func whenDiesDoubleBomb(card: Card) -> void:
	var tempCardArray: Array[Card] = %YourPlace.cardSlots
	for i in range(0,5):
		if tempCardArray[i]!=null and tempCardArray[i].cardName != "Double Bomb":
			tempCardArray[i].get_damaged(2, true, i)
			multiplayer.rpc(Global.peerID, get_parent(), "card_methods_rpc", ["get_damaged", 2, false, i])
	tempCardArray = %EnemyPlace.cardSlots
	for i in range(0,5):
		if tempCardArray[i]!=null:
			tempCardArray[i].get_damaged(2, false, i)
			multiplayer.rpc(Global.peerID, get_parent(), "card_methods_rpc", ["get_damaged", 2, true, i])
func whenDiesPacifist(card: Card) -> void:
	%YourHand.update_your_life(4)
	multiplayer.rpc(Global.peerID, %EnemyPlace, "update_enemy_life", [4])
	%EnemyPlace.update_enemy_life(4)
	multiplayer.rpc(Global.peerID, %YourHand, "update_your_life", [4])
func whenDiesRestfulCrystal(card: Card) -> void:
	multiplayer.rpc(Global.peerID, %YourHand, "draw_card")
func whenDiesRecklessFighter(card: Card):
	%YourHand.update_your_life(-8)
	multiplayer.rpc(Global.peerID, %EnemyPlace, "update_enemy_life", [-8])
func whenDiesLesserUrsa(card: Card):
	for i in range(0, 5):
		if %YourPlace.cardSlots[i]!=null:
			%YourPlace.cardSlots[i].change_current_attack(1)
			multiplayer.rpc(Global.peerID, %EnemyPlace, "card_methods_rpc", ["change_current_attack", 1, false, i])
