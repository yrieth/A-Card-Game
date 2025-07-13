extends Button



func _on_pressed() -> void:
	if Global.yourTurn:
		get_parent().change_turn()
		multiplayer.rpc(Global.peerID, get_parent(), "change_turn")
