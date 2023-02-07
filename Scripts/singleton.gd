extends Node

signal new_player_pos(pos)

var deadPointPos
var objectList = []
signal element_created
signal element_deleted
signal won
var candie = false

var picked = 0

func add_item():
	print('elemento')
	picked += 1
	if picked > 2:
		emit_signal('won')

func delete_element(item):
	for element in objectList:
		if element == item:
			objectList.erase(item)

# Called when the node enters the scene tree for the first time.
func _ready():
	objectList = []
	pass # Replace with function body.
	
@rpc('any_peer')
func receive_player_pos(pos):
	emit_signal('new_player_pos',pos)
	

