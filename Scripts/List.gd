extends Node2D

var visibleMenu = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.connect('element_created',Callable(self, "create_elements"))

func create_elements():
	$CanvasLayer/Movil/items/'1'.texture
	print()
	$CanvasLayer/Movil/items/'1'.texture = load(Globals.objectList[0].texture)
	$CanvasLayer/Movil/items/'2'.texture = load(Globals.objectList[1].texture)
	$CanvasLayer/Movil/items/'3'.texture = load(Globals.objectList[2].texture)

func _unhandled_key_input(event):
	#if not is_multiplayer_authority(): return
	if event.is_action_pressed("list") and not $AnimationPlayer.is_playing():
		if visibleMenu:
			$AnimationPlayer.play("hidden")
			visibleMenu = false
		else:
			$AnimationPlayer.play("show")
			visibleMenu = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.
