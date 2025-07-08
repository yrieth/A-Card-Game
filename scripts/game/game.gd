extends Control


const MAX_CLIENTS = 1

func _ready() -> void:
	var peer = ENetMultiplayerPeer.new()
	if Global.isServer:
		peer.create_server(Global.port, MAX_CLIENTS)
		multiplayer.multiplayer_peer = peer
		multiplayer.peer_connected.connect(assign_id)
	elif Global.isClient:
		peer.create_client(Global.ipAdress, Global.port)
		multiplayer.multiplayer_peer = peer
		Global.peerID = 1
	
	print(Global.ipAdress + ':' + str(Global.port))

func assign_id(id: int) -> void:
	Global.peerID = id

#func _process(delta: float) -> void:
	#print(Global.peerID)
