class_name WakeupState
extends CharacterState

@export var player: PlayerCharacter

func enter() -> void:	
	player.play_animation((player.states[player.State.WAKEUP]).to_lower())
	
func update(_delta: float) -> void:
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == (player.states[player.State.WAKEUP]).to_lower():
		transition.emit(player.states[player.State.IDLE])

func exit() -> void:
	player.stop_animation()
