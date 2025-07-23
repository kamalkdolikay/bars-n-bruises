class_name EnemyHurtState1
extends CharacterState

@export var enemy: EnemyCharacter
@export var knockback_intensity: float

var is_knockedout: bool = false

func enter() -> void:
	enemy.animation_player.play("hurt1")

func update(_delta: float) -> void:
	if not is_knockedout:
		var direction := Vector2.RIGHT if enemy.get_facing_direction().x < 0 else Vector2.LEFT
		enemy.velocity = direction * knockback_intensity
		enemy.move_and_slide()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt1":
		is_knockedout = true
		transition.emit(enemy.states[enemy.State.IDLE])

func exit() -> void:
	enemy.animation_player.stop()
	is_knockedout = false
