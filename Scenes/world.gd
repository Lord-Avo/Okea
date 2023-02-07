extends Node2D

var item = preload("res://Scenes/item.tscn")
var spawnpos = []
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.deadPointPos = $deadPoint.position
	for position in $itemsPoints.get_children():
		spawnpos.push_front(position.position)
	for item in $items.get_children():
		var aux = spawnpos.pick_random()
		item.position = aux
		spawnpos.erase(aux)
	no_duplicates()
	Globals.objectList = $items.get_children()
	Globals.emit_signal('element_created')
	print('aaaa')
	pass # Replace with function body.

func no_duplicates():
	var names = []
	var duplicated = false
	for item in $items.get_children():
		if names.has(item.namePro):
			duplicated = true
			item._ready()
		else:
			names.push_back(item.namePro)
	if duplicated: no_duplicates()

	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
