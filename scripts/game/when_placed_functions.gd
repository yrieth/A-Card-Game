extends Node



func whenPlacedTechAprentice(card: Card) -> void:
	%YourHand.draw_card()
func whenPlacedBeastRider(card: Card) -> void:
	card.asleep = false
func whenPlacedFatiguedMill(card: Card) -> void:
	%YourHand.draw_card()
	multiplayer.rpc(Global.peerID, %YourHand, "draw_card")
	await get_tree().create_timer(0.8).timeout
	%YourHand.draw_card()
	multiplayer.rpc(Global.peerID, %YourHand, "draw_card")
func whenPlacedFriedChicken(card: Card) -> void:
	card.asleep = false
	var emptySlots: int = %EnemyPlace.cardSlots.count(null)
	if emptySlots > 1:
		emptySlots = 2
		var i: int = 0
		while emptySlots > 0:
			if %EnemyPlace.cardSlots[i] == null:
				emptySlots-=1
				%EnemyPlace.put_card(0, i)
				multiplayer.rpc(Global.peerID, %YourPlace, "put_card_rpc", [0, i])
			i+=1
	elif emptySlots == 1:
		var i: int = 0
		while emptySlots > 0:
			if %EnemyPlace.cardSlots[i] == null:
				emptySlots-=1
				%EnemyPlace.put_card(0, i)
				multiplayer.rpc(Global.peerID, %YourPlace, "put_card_rpc", [0, i])
			i+=1
func whenPlacedMathTeacher(card: Card) -> void:
	var target: int = await %ChoiceNode.choose_ally(false)
	if target != -1:
		var currentAttack: int = %YourPlace.cardSlots[target].currentAttack
		%YourPlace.cardSlots[target].change_current_attack(currentAttack)
		multiplayer.rpc(Global.peerID, get_parent(), "card_methods_rpc", ["change_current_attack", currentAttack, false, target])
func whenPlacedRenegadeRogue(card: Card) -> void:
	var target: int = await %ChoiceNode.choose_enemy(false)
	if target != -1:
		%EnemyPlace.cardSlots[target].get_damaged(5, false, target)
		multiplayer.rpc(Global.peerID, get_parent(), "card_methods_rpc", ["get_damaged", 5, true, target])
func whenPlacedVoid(card: Card) -> void:
	var tempCardArray: Array[Card] = %YourPlace.cardSlots
	for i in range(0,5):
		if tempCardArray[i]!=null and tempCardArray[i].cardName != "Void":
			tempCardArray[i].get_damaged(20, true, i)
			multiplayer.rpc(Global.peerID, get_parent(), "card_methods_rpc", ["get_damaged", 20, false, i])
	tempCardArray = %EnemyPlace.cardSlots
	for i in range(0,5):
		if tempCardArray[i]!=null and tempCardArray[i].cardName != "Void":
			tempCardArray[i].get_damaged(20, false, i)
			multiplayer.rpc(Global.peerID, get_parent(), "card_methods_rpc", ["get_damaged", 20, true, i])
func whenPlacedSanok(card: Card) -> void:
	var tempCardArray: Array[Card] = %YourPlace.cardSlots
	var yourCards: int = 0
	for i in range(0, 5):
		if tempCardArray[i]!=null:
			yourCards += 1
	if yourCards == 1:
		var target: int = await %ChoiceNode.choose_ally(true)
		if target == 5:
			var amount: int = 15-%YourHand.yourLife
			%YourHand.update_your_life(amount)
			multiplayer.rpc(Global.peerID, %EnemyPlace, "update_enemy_life", [amount])
		else :
			card.change_max_life(14)
			multiplayer.rpc(Global.peerID, get_parent(), "card_methods_rpc", ["change_max_life", 14, false, target])
func whenPlacedBureaucrat(card: Card) -> void:
	get_parent().maxGold += 1
	%YourHand.update_gold()
func whenPlacedAncient(card:Card) -> void:
	var amount: int = 1-%EnemyPlace.enemyLife
	%EnemyPlace.update_enemy_life(amount)
	multiplayer.rpc(Global.peerID, %YourHand, "update_your_life", [amount])
func whenPlacedDoubleBomb(card: Card) -> void:
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
func whenPlacedArcanist(card: Card) -> void:
	var tempCardArray: Array[Card] = %EnemyPlace.cardSlots
	for i in range(0,5):
		if tempCardArray[i]!=null:
			tempCardArray[i].get_damaged(1, false, i)
			multiplayer.rpc(Global.peerID, get_parent(), "card_methods_rpc", ["get_damaged", 1, true, i])
func whenPlacedPyromaniac(card: Card) -> void:
	var target: int = await %ChoiceNode.choose_enemy(true)
	var tempCardArray: Array[Card] = %YourPlace.cardSlots
	if target == 5:
		%EnemyPlace.update_enemy_life(-6)
		multiplayer.rpc(Global.peerID, %YourHand, "update_your_life", [-6])
	else:
		%EnemyPlace.cardSlots[target].get_damaged(6, false, target)
		multiplayer.rpc(Global.peerID, get_parent(), "card_methods_rpc", ["get_damaged", 6, true, target])
	for i in range(0,5):
		if tempCardArray[i] != null and tempCardArray[i].cardName == "Pyromaniac":
			tempCardArray[i].get_damaged(1, true, i)
			multiplayer.rpc(Global.peerID, get_parent(), "card_methods_rpc", ["get_damaged", 1, false, i])
			return
func whenPlacedDrowHuntress(card: Card) -> void:
	var target: int = await %ChoiceNode.choose_enemy(false)
	if target!=-1:
		%EnemyPlace.cardSlots[target].get_silanced()
		multiplayer.rpc(Global.peerID, get_parent(), "card_methods_rpc", ["get_silanced", 0, true, target])
func whenPlacedBloodHound(card: Card) -> void:
	var target: int = await %ChoiceNode.choose_ally(false)
	if %YourPlace.cardSlots[target].cardName == card.cardName:
		card.get_damaged(2, true, target)
		multiplayer.rpc(Global.peerID, get_parent(), "card_methods_rpc", ["get_damaged", 2, false, target])
		
	else:
		%YourPlace.cardSlots[target].get_silanced()
		multiplayer.rpc(Global.peerID, get_parent(), "card_methods_rpc", ["get_silanced", 0, false, target])
func whenPlacedSilancer(card: Card)->void:
	for i in range(0,5):
		if %EnemyPlace.cardSlots[i] != null:
			%EnemyPlace.cardSlots[i].get_silanced()
			multiplayer.rpc(Global.peerID, get_parent(), "card_methods_rpc", ["get_silanced", 0, true, i])
	for i in range(0,5):
		if %YourPlace.cardSlots[i] != null and %YourPlace.cardSlots[i].cardName != "Silancer":
			%YourPlace.cardSlots[i].get_silanced()
			multiplayer.rpc(Global.peerID, get_parent(), "card_methods_rpc", ["get_silanced", 0, false, i])
func whenPlacedConfusedOwl(card: Card)->void:
	var target: int = await %ChoiceNode.choose_ally(false)
	%YourPlace.cardSlots[target].get_silanced()
	multiplayer.rpc(Global.peerID, get_parent(), "card_methods_rpc", ["get_silanced", 0, false, target])
func whenPlacedBes(card: Card)->void:
	%YourHand.update_your_life(-2)
	multiplayer.rpc(Global.peerID, %EnemyPlace, "update_enemy_life", [-2])
func whenPlacedTraitorPriest(card: Card)->void:
	%EnemyPlace.update_enemy_life(3)
	multiplayer.rpc(Global.peerID, %YourHand, "update_your_life", [3])
func whenPlacedFellowPriest(card: Card)->void:
	%YourHand.update_your_life(7)
	multiplayer.rpc(Global.peerID, %EnemyPlace, "update_enemy_life", [7])
