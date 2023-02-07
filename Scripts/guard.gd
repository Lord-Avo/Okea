extends CharacterBody2D

var playerPos = []
var world = preload('res://Scenes/world.tscn')

func _draw():
	return
	var positions = $NavigationAgent2D.get_current_navigation_path()
	var aux = to_local(position)
	for auxv in positions:
		var next = to_local(auxv)
		draw_line(aux, next, Color(255, 0, 0), 1)
		aux = next
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group('Ikea')
	var spawnPoints = world.instantiate().find_child('SpawnPoints')
	randi()
	position = spawnPoints.get_children()[randi_range(0,spawnPoints.get_child_count()-1)].position
	#position = spawnPoint.position
	var tileMap = world.instantiate().find_child('TileMap')
	$NavigationAgent2D.set_navigation_map(tileMap)
	if multiplayer.is_server():
		Globals.connect('new_player_pos',Callable(self, "_new_target"))
	$deadCollision.disabled = true
	await get_tree().create_timer(1).timeout
	$deadCollision.disabled = false
func _physics_process(delta):
	#print($NavigationAgent2D.get_next_path_position().normalized().angle() * (180/PI))
	pass
func _new_target(pos):
	playerPos.push_back(pos)



