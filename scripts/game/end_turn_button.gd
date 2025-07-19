extends Button


func _on_button_up() -> void:
	if Global.yourTurn and self.has_focus():
		get_parent().change_turn()
		multiplayer.rpc(Global.peerID, get_parent(), "change_turn")
