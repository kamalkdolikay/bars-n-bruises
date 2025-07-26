class_name EnemyHurtState2
extends CharacterState

@export var enemy: EnemyCharacter
@export var knockback_intensity: float

const WAKEUP_DELAY := 0.5

var is_knocked_out: bool = false
var wakeup_started: bool = false

func enter() -> void:
	enemy.play_animation((enemy.states[enemy.State.HURT2]).to_lower())

func update(_delta: float) -> void:
	if not is_knocked_out:
		var direction := enemy.get_knockback_direction()
		enemy.velocity = direction * knockback_intensity
		enemy.move_and_slide()
	elif not wakeup_started:
		start_wakeup_delay()

func start_wakeup_delay() -> void:
	wakeup_started = true
	await get_tree().create_timer(WAKEUP_DELAY).timeout
	if is_knocked_out and wakeup_started:
		if enemy.is_dead():
			play_fade_out_and_destroy()
		else:
			enemy.play_animation((enemy.states[enemy.State.WAKEUP]).to_lower())

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == (enemy.states[enemy.State.HURT2]).to_lower():
		is_knocked_out = true
	elif anim_name == (enemy.states[enemy.State.WAKEUP]).to_lower():
		transition.emit(enemy.states[enemy.State.WAKEUP])

func play_fade_out_and_destroy() -> void:
	var tween = create_tween()
	tween.tween_property(enemy, "modulate:a", 0.0, 1.0)
	tween.tween_callback(enemy.queue_free)

func exit() -> void:
	enemy.stop_animation()
	is_knocked_out = false
	wakeup_started = false
