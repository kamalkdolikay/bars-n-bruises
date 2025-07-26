class_name EnemyStateMachine
extends Node

@export var current_state: CharacterState

var states: Dictionary = {}
var parent_node_name: String

func _ready() -> void:
	_register_states()

func _process(delta: float) -> void:
	if current_state != null:
		current_state.update(delta)

func _register_states() -> void:
	for child in get_children():
		if child is CharacterState:
			add_state(child)

func add_state(state: CharacterState) -> void:
	var state_name := state.name.to_lower()
	states[state_name] = state
	state.transition.connect(on_state_transition)

func on_state_transition(state_name: String) -> void:
	if current_state.name == state_name:
		return
		
	if not states.has(state_name.to_lower()):
		push_warning("State '%s' not registered in state machine." % state_name)
		return
	
	current_state.exit()
	current_state = states[state_name.to_lower()]
	current_state.enter()
