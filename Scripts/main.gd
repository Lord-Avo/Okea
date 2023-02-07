extends Node2D

const SERVER_PORT = 9999
const SERVER_IP = 'localhost'
var enet_peer = ENetMultiplayerPeer.new()

var playerScene = preload("res://Scenes/player.tscn")
var guardScene = preload('res://Scenes/guard.tscn')
var worldScene = preload("res://Scenes/world.tscn")

var hostPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect('won',Callable(self,'won'))
	pass # Replace with function body.
func won():
	$won.show()	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_host_pressed():
	$background.hide()
	$Menu/Host.hide()
	$Menu/Join.hide()
	$Menu/Start.show()
	$Menu/ip.hide()
	$lobbyMap.show()
	
	$Menu/msg.text = 'Waiting for players... or start by your own..'
	enet_peer.create_server(SERVER_PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.disconnect(client_dis)
	hostPlayer = add_player(multiplayer.get_unique_id())
	#$mainMenuCamera.make_current()
	#FALTA AGREGAR JUGADOR. SE HACE DESPUES de comenzar la partida
	
func _on_join_pressed():
	$background.hide()
	$Menu/Host.hide()
	$Menu/Join.hide()
	$Menu/ip.hide()
	$lobbyMap.show()
	#$mainMenuCamera.make_current()
	print('Cliente')
	enet_peer.create_client($Menu/ip.text,SERVER_PORT)
	multiplayer.multiplayer_peer = enet_peer
	multiplayer.server_disconnected.connect(server_dead)
	print(multiplayer.get_peers().size())
	pass # Replace with function body.
	
func server_dead():
	queue_free()
	get_tree().change_scene_to_file("res://Scenes/lobby_ended.tscn")
	pass	
	
func client_dis(peer_id):
	print('cliente desconectado')
	delete_peer.rpc(peer_id)
	delete_peer(peer_id)
	pass
	
@rpc('any_peer')
func delete_peer(id):
	var player = get_node_or_null(str(id))
	if player:
		player.queue_free()
	
@rpc('any_peer')
func start_game():
	$mainTheme.stop()
	$vegeta.play()
	$lobbyMap.hide()
	$Menu.hide()
	$World.show()
	spawn_guard.rpc()
	if not multiplayer.has_multiplayer_peer():
		spawn_guard()	
	Globals.candie = true
	await get_tree().create_timer(5).timeout
	guard_Spawner()

func guard_Spawner():
	spawn_guard.rpc()
	if not multiplayer.has_multiplayer_peer():
		spawn_guard()	
	await get_tree().create_timer(5).timeout
	guard_Spawner()
		
@rpc('any_peer')
func spawn_guard():
	var guard = guardScene.instantiate()
	add_child(guard)
	
func add_player(peer_id):
	var player = playerScene.instantiate()
	player.name = str(peer_id)
	add_child(player)
	$Menu/msg.text = str(multiplayer.get_peers().size()) + ' Connected players'
	get_tree().create_timer(2).timeout
	if hostPlayer :
		hostPlayer.set_texture_host.rpc(hostPlayer.rpcTexture)
	return player

func _on_start_pressed():
	start_game.rpc()
	start_game()

func _on_quit_pressed():
	get_tree().quit()

func _on_quit_won_pressed():
	get_tree().quit()
