class_name EnemyHurtState1
extends CharacterState

@export var enemy: BaseEnemy
@export var knockback_intensity: float

var is_knocked_out: bool = false

func enter() -> void:
	enemy.play_animation((enemy.states[enemy.State.HURT1]).to_lower())

func update(_delta: float) -> void:
	if not is_knocked_out:
		var direction := enemy.get_knockback_direction()
		enemy.velocity = direction * knockback_intensity
		enemy.move_and_slide()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == (enemy.states[enemy.State.HURT1]).to_lower():
		is_knocked_out = true
		if enemy.hit_type == DamageReceiver.HitType.POWER:
			enemy.collateral_emitter.set_deferred("monitoring", true)
			transition.emit(enemy.states[enemy.State.FLY])
		else:
			transition.emit(enemy.states[enemy.State.IDLE])

func exit() -> void:
	enemy.stop_animation()
	is_knocked_out = false
