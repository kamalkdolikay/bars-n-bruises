class_name WalkState
extends CharacterState

@export var player: PlayerCharacter

func enter() -> void:
	player.play_animation((player.states[player.State.WALK]).to_lower())

func update(_delta: float):
	var direction := player.get_movement_direction()
	
	# Update sprite flip
	player.get_sprite_position(direction)
	
	# Apply movement
	player.velocity = direction.normalized() * player.move_speed
	player.move_and_slide()
	
	# Check configured input actions for state transitions
	for input_action in player.input_transitions.keys():
		if Input.is_action_just_pressed(input_action):
			transition.emit(player.input_transitions[input_action])
			return
	
	# Transition to Idle if no movement
	if direction == Vector2.ZERO:
		transition.emit(player.states[player.State.IDLE])

func exit() -> void:
	player.stop_animation()
