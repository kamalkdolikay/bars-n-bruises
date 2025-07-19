class_name HurtState1
extends CharacterState

@export var player: PlayerCharacter
@export var knockback_intensity: float

var is_knockedout: bool = false

func enter() -> void:
	if not player.animation_player.is_connected("animation_finished", Callable(self, "_on_animation_finished")):
		player.animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))
		
	player.animation_player.play("hurt1")

func update(_delta: float) -> void:
	if not is_knockedout:
		player.velocity = Vector2.LEFT * knockback_intensity
		player.move_and_slide()

func _on_animation_finished(_anim_name: String) -> void:
	is_knockedout = true
	if _anim_name == "hurt1":
		transition.emit("Idle")

func exit() -> void:
	player.animation_player.stop()
	is_knockedout = false
