extends Button

func _pressed() -> void:
	var port:int = int(%PORTInput.text)
	if  1024 < port and port < 65536:
		Global.port = port
	elif %PORTInput.text == "":
		pass
	else:
		print("Invalid Port")
		return
	
	Global.isServer = true
	get_tree().change_scene_to_file("res://scenes/Game.tscn")
