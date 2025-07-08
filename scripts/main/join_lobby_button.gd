extends Button

func _pressed() -> void:
	if %IPInput.text != "" and %IPInput.text.is_valid_ip_address() :
		Global.ipAdress = %IPInput.text
	elif %IPInput.text == "":
		pass
	else:
		print("Invalid IP")
		return
	var port:int = int(%PORTInput.text)
	if  1024 < port and port < 65536:
		Global.port = port
	elif %PORTInput.text == "":
		pass
	else:
		print("Invalid Port")
		return
	
	Global.isClient = true
	get_tree().change_scene_to_file("res://scenes/Game.tscn")
	
