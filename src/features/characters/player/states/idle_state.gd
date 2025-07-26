class_name IdleState
extends CharacterState

@export var player: PlayerCharacter

func enter() -> void:
	player.play_animation((player.states[player.State.IDLE]).to_lower())
	
func update(_delta: float) -> void:
	for input_action in player.input_transitions.keys():
		if Input.is_action_just_pressed(input_action):
			transition.emit(player.input_transitions[input_action])
			return
	
	if player.get_movement_direction() != Vector2.ZERO:
		transition.emit(player.states[player.State.WALK])

func exit() -> void:
	player.stop_animation()
