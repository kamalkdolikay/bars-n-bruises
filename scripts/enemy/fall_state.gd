class_name EnemyFallState
extends CharacterState

@export var enemy: EnemyCharacter

func enter() -> void:
	enemy.animation_player.play("fall")

func update(_delta: float) -> void:
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fall":
		transition.emit(enemy.states[enemy.State.WAKEUP])

func exit() -> void:
	enemy.animation_player.stop()
