class_name EnemyLand2State
extends CharacterState

@export var enemy: BaseEnemy

func enter() -> void:
	enemy.play_animation((enemy.states[enemy.State.LAND2]).to_lower())
	await get_tree().create_timer(0.3).timeout
	enemy.animation_player.pause()
	await get_tree().create_timer(0.3).timeout
	enemy.animation_player.play()

func update(_delta: float) -> void:
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == (enemy.states[enemy.State.LAND2]).to_lower():
		transition.emit(enemy.states[enemy.State.IDLE])

func exit() -> void:
	enemy.stop_animation()
