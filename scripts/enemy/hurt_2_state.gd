class_name EnemyHurtState2
extends CharacterState

@export var enemy: EnemyCharacter
@export var knockback_intensity: float

enum State { KNOCKEDOUT, GETUP }

var hurt_state := {
	State.KNOCKEDOUT: "hurt2",
	State.GETUP: "wakeup",
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
			enemy.queue_free()
		else:
			enemy.animation_player.play(hurt_state[State.GETUP])

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == hurt_state[State.KNOCKEDOUT]:
		is_knocked_out = true
	elif anim_name == hurt_state[State.GETUP]:
		transition.emit(enemy.states[enemy.State.WAKEUP])

func exit() -> void:
	enemy.animation_player.stop()
	is_knocked_out = false
	wakeup_started = false
