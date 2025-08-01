class_name HurtState2
extends CharacterState

@export var player: PlayerCharacter
@export var knockback_intensity: float

const WAKEUP_DELAY := 0.5

enum LocalState { KNOCKEDOUT, WAKEUP }

var hurt_state := {
	LocalState.KNOCKEDOUT: "hurt2",
	LocalState.WAKEUP: "wakeup",
}
var is_knocked_out := false
var wakeup_started := false

func enter() -> void:
	player.play_animation(hurt_state[LocalState.KNOCKEDOUT])
	player.collision_shape.set_deferred("disabled", true)
	player.damage_shape.set_deferred("disabled", true)

func update(_delta: float) -> void:
	if not is_knocked_out:
		var direction = player.get_knockback_direction()
		player.velocity = direction * knockback_intensity
		player.move_and_slide()
	elif not wakeup_started:
		start_wakeup_delay()

func start_wakeup_delay() -> void:
	wakeup_started = true
	await get_tree().create_timer(WAKEUP_DELAY).timeout
	if is_knocked_out and wakeup_started:
		if player.is_dead():
			pass
			#play_fade_out_and_destroy()
		else:
			player.play_animation(hurt_state[LocalState.WAKEUP])

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == hurt_state[LocalState.KNOCKEDOUT]:
		is_knocked_out = true
	elif anim_name == hurt_state[LocalState.WAKEUP]:
		transition.emit(player.states[player.State.WAKEUP])

func play_fade_out_and_destroy() -> void:
	var tween = create_tween()
	tween.tween_property(player, "modulate:a", 0.0, 1.0)
	tween.tween_callback(player.queue_free)

func exit() -> void:
	player.stop_animation()
	player.collision_shape.set_deferred("disabled", false)
	player.damage_shape.set_deferred("disabled", false)
	is_knocked_out = false
	wakeup_started = false
