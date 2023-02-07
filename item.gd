extends Node2D

var names = ['Vegeta','Timo','Patito', 'Albondiga','Sarten','planta','alfombra']
var textures = ["res://assets/IMG_0772.png",
"res://assets/IMG_0771.png",
"res://assets/patito.png",
"res://assets/70_meatball_dish.png",
"res://assets/sarten.png",
"res://assets/maceta1.png",
"res://assets/Alfombra.png"]

var random_number = 0
var namePro = ''
var texture = ''

# Called when the node enters the scene tree for the first time.
func _ready():
	randi()
	random_number = randi_range(0,names.size()-1)
	texture = textures[random_number]
	$image.texture = load(textures[random_number])
	namePro = names[random_number]
	#Globals.objectList.push(self)

func _on_area_2d_body_entered(body):
	if body.is_in_group('Players'):
		Globals.add_item()
		queue_free()
