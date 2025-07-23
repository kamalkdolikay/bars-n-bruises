class_name EnemyWakeupState
extends CharacterState

@export var enemy: EnemyCharacter

func enter() -> void:
	enemy.animation_player.play("wakeup")
	
func update(_delta: float) -> void:
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "wakeup":
		transition.emit(enemy.states[enemy.State.IDLE])

func exit() -> void:
	enemy.animation_player.stop()
