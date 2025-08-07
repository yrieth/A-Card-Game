extends Button



func _on_pressed() -> void:
	multiplayer.rpc(Global.peerID, %EnemyPlace, "update_enemy_life", [-%YourHand.yourLife])
	%YourHand.update_your_life(-%YourHand.yourLife)
	
