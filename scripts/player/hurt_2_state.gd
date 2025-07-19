class_name HurtState2
extends CharacterState

@export var player: PlayerCharacter
@export var knockback_intensity: float

enum State { KNOCKEDOUT, GETUP }

var hurt_state := {
	State.KNOCKEDOUT: "hurt2",
	State.GETUP: "wakeup",
}
var is_knocked_out := false
var wakeup_started := false

func enter() -> void:
	if not player.animation_player.is_connected("animation_finished", Callable(self, "_on_animation_finished")):
		player.animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))

	is_knocked_out = false
	wakeup_started = false
	player.animation_player.play(hurt_state[State.KNOCKEDOUT])

func update(_delta: float) -> void:
	if not is_knocked_out:
		player.velocity = Vector2.LEFT * knockback_intensity
		player.move_and_slide()
	elif not wakeup_started:
		wakeup_started = true
		start_wakeup_delay()

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == hurt_state[State.KNOCKEDOUT]:
		is_knocked_out = true
	elif anim_name == hurt_state[State.GETUP]:
		transition.emit("Wakeup")

func start_wakeup_delay() -> void:
	await get_tree().create_timer(0.5).timeout
	if is_knocked_out and wakeup_started:
		player.animation_player.play(hurt_state[State.GETUP])

func exit() -> void:
	player.animation_player.stop()
	is_knocked_out = false
	wakeup_started = false
