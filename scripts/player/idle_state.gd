class_name IdleState
extends CharacterState

@export var player: PlayerCharacter

func enter() -> void:
	player.animation_player.play("idle")
	
func update(_delta: float) -> void:
	# Check configured input actions for state transitions
	for input_action in player.input_transitions.keys():
		if Input.is_action_just_pressed(input_action):
			transition.emit(player.input_transitions[input_action])
			return
	
	# Check for movement to transition to Walk
	if player.get_movement_direction() != Vector2.ZERO:
		transition.emit("Walk")

func exit() -> void:
	player.animation_player.stop()
