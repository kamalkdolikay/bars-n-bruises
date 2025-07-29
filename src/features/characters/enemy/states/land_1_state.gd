class_name EnemyLand1State
extends CharacterState

@export var enemy: BaseEnemy

var fall_speed: float = 150.0
var current_position: float = 0.0
var has_landed: bool = false

func enter() -> void:
	enemy.play_animation((enemy.states[enemy.State.LAND1]).to_lower())
	current_position = 0
	has_landed = false
	enemy.position.y = current_position

func update(delta: float) -> void:
	if has_landed:
		return

	current_position += fall_speed * delta

	if current_position >= enemy.ground_position:
		current_position = enemy.ground_position
		has_landed = true
		on_landing()

	enemy.position.y = current_position
	enemy.move_and_slide()

func on_landing() -> void:
	transition.emit(enemy.states[enemy.State.LAND2])

func exit() -> void:
	enemy.stop_animation()
