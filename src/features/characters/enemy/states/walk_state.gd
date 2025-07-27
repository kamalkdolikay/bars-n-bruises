class_name EnemyWalkState
extends CharacterState

@export var enemy: BaseEnemy

func enter() -> void:
	enemy.play_animation((enemy.states[enemy.State.WALK]).to_lower())
	
func update(_delta: float) -> void:
	var direction := enemy.get_movement_direction()
	if direction == Vector2.ZERO:
		transition.emit(enemy.states[enemy.State.IDLE])
	
	enemy.get_sprite_position()
	enemy.velocity = direction.normalized() * enemy.speed
	enemy.move_and_slide()

func exit() -> void:
	enemy.stop_animation()
