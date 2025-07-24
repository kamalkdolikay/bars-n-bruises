class_name EnemyStateMachine
extends Node

@export var current_state: CharacterState
@export var enemy: EnemyCharacter

var states: Dictionary = {}
var parent_node_name: String

func _ready() -> void:
	for child in get_children():
		if child is CharacterState:
			states[child.name.to_lower()] = child
			child.transition.connect(on_state_transition)
			
	enemy.enemy_hurt_emitter.connect(on_enemy_hurt)
	enemy.enemy_attack_emitter.connect(on_enemy_attack)

func _process(delta: float) -> void:
	if current_state != null:
		current_state.update(delta)
		
func on_state_transition(state_name: String) -> void:
	if current_state.name == state_name:
		return
	
	current_state.exit()
	current_state = states[state_name.to_lower()]
	current_state.enter()

func on_enemy_hurt(state: String) -> void:
	on_state_transition(state)

func on_enemy_attack() -> void:
	on_state_transition("Attack1")
