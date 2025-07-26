class_name EnemyFlyState
extends CharacterState

@export var enemy: EnemyCharacter

func enter() -> void:
	enemy.collision_shape.set_deferred("disabled", true)	
	enemy.play_animation((enemy.states[enemy.State.FLY]).to_lower())

func update(_delta: float) -> void:
	var direction := enemy.get_knockback_direction()
	enemy.velocity = direction * enemy.flight_speed
	enemy.move_and_slide()

func _on_collateral_damage_emitter_body_entered(_wall: AnimatableBody2D) -> void:
	transition.emit(enemy.states[enemy.State.FALL])

func exit() -> void:
	enemy.stop_animation()
	enemy.collision_shape.set_deferred("disabled", false)
	enemy.collateral_emitter.set_deferred("monitoring", false)
