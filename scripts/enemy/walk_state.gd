class_name EnemyWalkState
extends CharacterState

@export var enemy: EnemyCharacter

func enter() -> void:
	enemy.animation_player.play("walk")
	
func update(_delta: float) -> void:
	var direction := enemy.get_movement_direction()
	if direction == Vector2.ZERO:
		transition.emit(enemy.states[enemy.State.IDLE])
	
	enemy.get_sprite_position(direction)
	enemy.velocity = direction.normalized() * enemy.speed
	enemy.move_and_slide()

func exit() -> void:
	enemy.animation_player.stop()
