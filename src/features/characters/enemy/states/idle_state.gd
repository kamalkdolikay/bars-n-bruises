class_name EnemyIdleState
extends CharacterState

@export var enemy: BaseEnemy

func enter() -> void:
	enemy.play_animation((enemy.states[enemy.State.IDLE]).to_lower())
	
func update(_delta: float) -> void:
	if enemy.get_movement_direction() != Vector2.ZERO:
		transition.emit(enemy.states[enemy.State.WALK])

func exit() -> void:
	enemy.stop_animation()
