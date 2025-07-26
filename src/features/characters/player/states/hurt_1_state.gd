class_name HurtState1
extends CharacterState

@export var player: PlayerCharacter
@export var knockback_intensity: float

var is_knocked_out: bool = false

func enter() -> void:
	player.play_animation((player.states[player.State.HURT1]).to_lower())

func update(_delta: float) -> void:
	if not is_knocked_out:
		var direction = player.get_knockback_direction()
		player.velocity = direction * knockback_intensity
		player.move_and_slide()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == (player.states[player.State.HURT1]).to_lower():
		is_knocked_out = true
		if player.hit_type == DamageReceiver.HitType.PUNCH:
			transition.emit(player.states[player.State.HURT2])
		else:
			transition.emit(player.states[player.State.IDLE])

func exit() -> void:
	player.stop_animation()
	is_knocked_out = false
