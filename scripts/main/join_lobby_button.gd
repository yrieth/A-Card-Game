extends Button

func _pressed() -> void:
	if %IPInput.text == "":
		pass
	else:
		var ipPortArray:Array[String] = %IPInput.text.split(":")
		var ip:String = ipPortArray[0]
		var port:int = int(ipPortArray[1])
		if ip.is_valid_ip_address() and 1024 < port and port < 65536:
			Global.ipAdress = ip
			Global.port = port
		else:
			print("Invalid ip or port")
			return
	


	
	Global.isClient = true
	get_tree().change_scene_to_file("res://scenes/Game.tscn")
	
