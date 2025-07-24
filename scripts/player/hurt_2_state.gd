class_name HurtState2
extends CharacterState

@export var player: PlayerCharacter
@export var knockback_intensity: float

enum State { KNOCKEDOUT, WAKEUP }

var hurt_state := {
	State.KNOCKEDOUT: "hurt2",
	State.WAKEUP: "wakeup",
}
var is_knocked_out := false
var wakeup_started := false

func enter() -> void:
	player.animation_player.play(hurt_state[State.KNOCKEDOUT])

func update(_delta: float) -> void:
	if not is_knocked_out:
		var direction = player.get_movement_direction()
		player.velocity = direction * knockback_intensity
		player.move_and_slide()
	elif not wakeup_started:
		wakeup_started = true
		start_wakeup_delay()

func start_wakeup_delay() -> void:
	await get_tree().create_timer(0.5).timeout
	if is_knocked_out and wakeup_started:
		if player.current_health <= 0:
			var tween = create_tween()
			tween.tween_property(player, "modulate:a", 0.0, 1.0)
			tween.tween_callback(player.queue_free)
		else:
			player.animation_player.play(hurt_state[State.WAKEUP])

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == hurt_state[State.KNOCKEDOUT]:
		is_knocked_out = true
	elif anim_name == hurt_state[State.WAKEUP]:
		transition.emit(player.states[player.State.WAKEUP])

func exit() -> void:
	player.animation_player.stop()
	is_knocked_out = false
	wakeup_started = false
