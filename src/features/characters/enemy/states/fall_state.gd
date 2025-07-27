class_name EnemyFallState
extends CharacterState

@export var enemy: BaseEnemy

func enter() -> void:
	enemy.play_animation((enemy.states[enemy.State.FALL]).to_lower())

func update(_delta: float) -> void:
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == (enemy.states[enemy.State.FALL]).to_lower():
		transition.emit(enemy.states[enemy.State.WAKEUP])

func exit() -> void:
	enemy.stop_animation()
