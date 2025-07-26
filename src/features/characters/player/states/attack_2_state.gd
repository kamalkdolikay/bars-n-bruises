class_name Attack2
extends CharacterState

@export var player: PlayerCharacter
@onready var damage_emitter: Area2D = $"../../DamageEmitter"

func enter() -> void:	
	damage_emitter.monitoring = true
	player.play_animation((player.states[player.State.ATTACK2]).to_lower())

func update(_delta: float):
	pass
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == (player.states[player.State.ATTACK2]).to_lower():
		transition.emit(player.states[player.State.IDLE])
	
func exit() -> void:
	player.stop_animation()
	damage_emitter.monitoring = false
