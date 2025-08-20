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
