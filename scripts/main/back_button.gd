extends Button



func _on_pressed() -> void:
	get_parent().visible = false
	%MainMenu.visible = true
