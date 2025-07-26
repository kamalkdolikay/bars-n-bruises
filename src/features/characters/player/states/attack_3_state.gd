class_name Attack3
extends CharacterState

@export var player: PlayerCharacter
@onready var damage_emitter: Area2D = $"../../DamageEmitter"

enum LocalState { START, END }

var attack_state := {
	LocalState.START: "attack3_start",
	LocalState.END: "attack3_finish",
}
var finish_attack: bool = false

func enter() -> void:
	player.play_animation(attack_state[LocalState.START])

func update(_delta: float):
	if finish_attack:
		damage_emitter.monitoring = true
		player.play_animation(attack_state[LocalState.END])
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == attack_state[LocalState.START]:
		finish_attack = true
	elif anim_name == attack_state[LocalState.END]:
		transition.emit(player.states[player.State.IDLE])
	
func exit() -> void:
	player.stop_animation()
	damage_emitter.monitoring = false
	finish_attack = false
