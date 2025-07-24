class_name EnemyFlyState
extends CharacterState

@export var enemy: EnemyCharacter

func enter() -> void:
	enemy.enemy_collision_shape.set_deferred("disabled", true)	
	enemy.animation_player.play("fly")

func update(_delta: float) -> void:
	var direction := Vector2.RIGHT if enemy.get_facing_direction().x < 0 else Vector2.LEFT
	enemy.velocity = direction * enemy.flight_speed
	enemy.move_and_slide()

func exit() -> void:
	enemy.animation_player.stop()
	enemy.enemy_collision_shape.set_deferred("disabled", false)
	enemy.collateral_damage_emitter.set_deferred("monitoring", false)
