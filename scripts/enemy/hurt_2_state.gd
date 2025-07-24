class_name EnemyHurtState2
extends CharacterState

@export var enemy: EnemyCharacter
@export var knockback_intensity: float

enum State { KNOCKEDOUT, WAKEUP }

var hurt_state := {
	State.KNOCKEDOUT: "hurt2",
	State.WAKEUP: "wakeup",
}
var is_knocked_out: bool = false
var wakeup_started: bool = false

func enter() -> void:
	enemy.animation_player.play(hurt_state[State.KNOCKEDOUT])

func update(_delta: float) -> void:
	if not is_knocked_out:
		var direction := Vector2.RIGHT if enemy.get_facing_direction().x < 0 else Vector2.LEFT
		enemy.velocity = direction * knockback_intensity
		enemy.move_and_slide()
	elif not wakeup_started:
		wakeup_started = true
		start_wakeup_delay()

func start_wakeup_delay() -> void:
	await get_tree().create_timer(0.5).timeout
	if is_knocked_out and wakeup_started:
		if enemy.current_health <= 0:
			var tween = create_tween()
			tween.tween_property(enemy, "modulate:a", 0.0, 1.0) # Fade alpha to 0 over 1 second
			tween.tween_callback(enemy.queue_free) # Free enemy after fade
		else:
			enemy.animation_player.play(hurt_state[State.WAKEUP])

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == hurt_state[State.KNOCKEDOUT]:
		is_knocked_out = true
	elif anim_name == hurt_state[State.WAKEUP]:
		transition.emit(enemy.states[enemy.State.WAKEUP])

func exit() -> void:
	enemy.animation_player.stop()
	is_knocked_out = false
	wakeup_started = false
