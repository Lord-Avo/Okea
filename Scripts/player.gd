extends CharacterBody2D

var world = preload('res://Scenes/world.tscn')
const SPEED = 80
var rpcTexture
var inv = true
var dead = false

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())
	
func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	if(event.is_action("left")):
		$AnimationPlayer.play("left")
	if(event.is_action("right")):
		$AnimationPlayer.play("right")
	if(event.is_action("up")):
		$AnimationPlayer.play("up")
	if(event.is_action("down")):
		$AnimationPlayer.play("down")

func _ready():
	$List.create_elements()
	add_to_group("Players")
	var textures = ["res://assets/Base.png", "res://assets/influencer-front.png"]
	randi()
	rpcTexture = textures[randi_range(0, textures.size()-1)]
	if not is_multiplayer_authority(): return
	set_texture.rpc(rpcTexture)
	$Camera.make_current()
	await get_tree().create_timer(4).timeout
	inv = false
	$List.create_elements()
	pass
	
@rpc('any_peer')
func set_texture(value):
	$Sprite.texture = load(value)
	pass
	
@rpc('any_peer')
func set_texture_host(value):
	$Sprite.texture = load(value)
	pass

func _physics_process(delta):
	if dead: return
	if not is_multiplayer_authority(): return

	var direction = Input.get_vector("left","right",'up','down')
	if direction:
		velocity.x = direction.x * SPEED
		velocity.y = direction.y * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	move_and_slide()


func _on_timer_timeout():
	if multiplayer.get_unique_id() != 1 :
		Globals.receive_player_pos.rpc_id(1,position)
	else:
		Globals.receive_player_pos(position)


func _on_area_body_entered(body):
	if not is_multiplayer_authority(): return
	if dead: return
	if body.is_in_group('Ikea'):
		$okea.play()
		print('ikea boy entro')
		if not is_multiplayer_authority(): return
		var tween := get_tree().create_tween()
		tween.tween_property($CanvasModulate, "color",Color.CRIMSON, 1)
		pass
	pass # Replace with function body.


func _on_area_body_exited(body):
	if not is_multiplayer_authority(): return
	if dead: return
	for bodyAux in $area.get_overlapping_bodies():
		if bodyAux.is_in_group('Ikea'):
			return
	$okea.stop()
	var tween := get_tree().create_tween()
	tween.tween_property($CanvasModulate, "color",Color.WHITE, 1)


func _on_dead_area_body_entered(body):
	if not is_multiplayer_authority(): return
	if not Globals.candie : return
	if body.is_in_group('Ikea'):
		print('ayy mori')
		dead = true
		var tween := get_tree().create_tween()
		tween.tween_property(self, "position",Globals.deadPointPos, 3)
		tween.tween_property($CanvasModulate, "color",Color.BLACK, 5)
		tween.tween_callback(kill)
		
func kill():
	end.rpc()
	
@rpc('call_local')
func end():
	#ueue_free()
	if not is_multiplayer_authority(): return
	
	#get_tree().change_scene_to_file("res://Scenes/dead.tscn")
