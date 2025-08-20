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
				var bumCard: Card = Card.new()
				bumCard.get_values(0)
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
