extends Node

var fsm: StateMachine
var body
var target_exists


func enter():
	print("Following state")
	fsm.area.body_exited.connect(on_body_exited)
	fsm.navigation.target_reached.connect(on_target_reached)
	target_exists = false
	for bodyAux in fsm.area.get_overlapping_bodies():
		if bodyAux.is_in_group('Players'):
			body = bodyAux
			target_exists = true
	if not target_exists:
		exit('Searching')
	
func on_target_reached():
	pass
	#print('new target')
	

func on_body_exited(bodyAux):
	if body.name == bodyAux.name:
		fsm.area.body_exited.disconnect(on_body_exited)
		fsm.navigation.target_reached.disconnect(on_target_reached)
		fsm.navigation.set_target_position(fsm.guard.position)
		exit('Searching')

func exit(next_state):
	fsm.change_to(next_state)

# Optional handler functions for game loop events
func process(delta):
	# Add handler code here
	return delta

func physics_process(delta):
	fsm.navigation.set_target_position(body.position)	
	if fsm.navigation.is_target_reachable():
		var current_agent_position : Vector2 = fsm.guard.global_transform.origin
		var next_path_position : Vector2 = fsm.navigation.get_next_path_position()
		var new_velocity : Vector2 = next_path_position - current_agent_position
		new_velocity = new_velocity.normalized()
		new_velocity = new_velocity * 50
		fsm.guard.velocity = new_velocity
		fsm.guard.move_and_slide()


func input(event):
	return event

func unhandled_input(event):
	return event

func unhandled_key_input(event):
	return event

func notification(what, flag = false):
	return [what, flag]

