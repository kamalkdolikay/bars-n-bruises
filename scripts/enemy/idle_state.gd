class_name EnemyIdleState
extends CharacterState

@export var enemy: EnemyCharacter

func enter() -> void:
	enemy.animation_player.play("idle")
	
func update(_delta: float) -> void:
	if enemy.get_movement_direction() != Vector2.ZERO:
		transition.emit("Walk")

func exit() -> void:
	enemy.animation_player.stop()
