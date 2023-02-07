extends Node

var fsm: StateMachine


func enter():
	print("Seach State")
	fsm.navigation.path_changed.connect(on_path_changed)
	fsm.navigation.target_reached.connect(on_target_reached)
	fsm.area.body_entered.connect(on_body_entered)
	check_if_can_follow()

func on_body_entered(body):
	if body.is_in_group('Players'):
		exit('Following')

func check_if_can_follow():
	if fsm.guard.playerPos.size() < 2:
		await get_tree().create_timer(2).timeout
		check_if_can_follow()
	else:
		randi()
		var pos = fsm.guard.playerPos[randi_range(0,fsm.guard.playerPos.size()-1)]
		fsm.navigation.set_target_position(pos)
		fsm.guard.playerPos = []

func on_target_reached():
	pass
	
func on_path_changed():
	pass

func exit(next_state):
	fsm.navigation.path_changed.disconnect(on_path_changed)
	fsm.navigation.target_reached.disconnect(on_target_reached)
	fsm.area.body_entered.disconnect(on_body_entered)
	fsm.change_to(next_state)

# Optional handler functions for game loop events
func process(delta):
	# Add handler code here
	return delta

func physics_process(delta):
	if fsm.navigation.is_target_reachable():
		var current_agent_position : Vector2 = fsm.guard.global_transform.origin
		var next_path_position : Vector2 = fsm.navigation.get_next_path_position()
		var new_velocity : Vector2 = next_path_position - current_agent_position
		new_velocity = new_velocity.normalized()
		new_velocity = new_velocity * 75
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
