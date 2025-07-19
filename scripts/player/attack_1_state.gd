class_name Attack1
extends CharacterState

@export var player: PlayerCharacter
@onready var damage_emitter: Area2D = $"../../DamageEmitter"

enum State { START, END }

var attack_state := {
	State.START: "attack1_start",
	State.END: "attack1_finish",
}
var finish_attack: bool = false

func enter() -> void:
	if not player.animation_player.is_connected("animation_finished", Callable(self, "_on_animation_finished")):
		player.animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))

	player.animation_player.play(attack_state[State.START])

func update(_delta: float):
	if finish_attack:
		damage_emitter.monitoring = true
		player.animation_player.play(attack_state[State.END])
	
func _on_animation_finished(animation_state: String) -> void:
	if animation_state == attack_state[State.START]:
		finish_attack = true
	elif animation_state == attack_state[State.END]:
		transition.emit("Idle")
	
func exit() -> void:
	player.animation_player.stop()
	damage_emitter.monitoring = false
	finish_attack = false
