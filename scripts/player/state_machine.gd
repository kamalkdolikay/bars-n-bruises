class_name CharacterStateMachine
extends Node

@export var current_state: CharacterState
@export var player: PlayerCharacter

var states: Dictionary = {}
var parent_node_name: String

func _ready() -> void:
	for child in get_children():
		if child is CharacterState:
			states[child.name.to_lower()] = child
			child.transition.connect(on_state_transition)
			
	player.hurt_emitter.connect(on_player_hurt)

func _process(delta: float) -> void:
	if current_state != null:
		current_state.update(delta)

func on_state_transition(state_name: String) -> void:
	if current_state.name == state_name:
		return
	
	current_state.exit()
	current_state = states[state_name.to_lower()]
	current_state.enter()

func on_player_hurt(state: String) -> void:
	on_state_transition(state)
