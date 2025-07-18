class_name WalkState
extends CharacterState

@export var player: PlayerCharacter

func enter() -> void:
	player.animation_player.play("walk")

func update(_delta: float):
	var direction := player.get_movement_direction()
	
	# Update sprite flip
	if direction.x > 0:
		player.sprite.flip_h = false
	elif direction.x < 0:
		player.sprite.flip_h = true
	
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
		transition.emit("Idle")

func exit() -> void:
	player.animation_player.stop()
