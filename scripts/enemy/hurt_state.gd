class_name HurtState
extends CharacterState

@export var enemy: EnemyCharacter
@export var knockback_intensity: float

enum State { KNOCKEDOUT, GETUP }

var hurt_state := {
	State.KNOCKEDOUT: "hurt",
	State.GETUP: "wakeup",
}
var is_knocked_out: bool = false
var wakeup_started: bool = false

func enter() -> void:
	enemy.animation_player.play(hurt_state[State.KNOCKEDOUT])

func update(_delta: float) -> void:
	if not is_knocked_out:
		var direction := enemy.get_movement_direction()
		enemy.velocity = direction * knockback_intensity
		enemy.move_and_slide()
	elif not wakeup_started:
		wakeup_started = true
		start_wakeup_delay()
		
func start_wakeup_delay() -> void:
	await get_tree().create_timer(0.5).timeout
	if is_knocked_out and wakeup_started:
		enemy.animation_player.play(hurt_state[State.GETUP])

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == hurt_state[State.KNOCKEDOUT]:
		is_knocked_out = true
	elif anim_name == hurt_state[State.GETUP]:
		transition.emit("Wakeup")

func exit() -> void:
	enemy.animation_player.stop()
	is_knocked_out = false
	wakeup_started = false
