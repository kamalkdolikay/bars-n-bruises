class_name Attack1
extends CharacterState

@export var player: PlayerCharacter

func enter() -> void:
	if not player.animation_player.is_connected("animation_finished", Callable(self, "_on_animation_finished")):
		player.animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))
		
	player.animation_player.play("attack1")

func update(_delta: float):
	pass
	
func _on_animation_finished(animation_state: String) -> void:
	if animation_state == "attack1":
		transition.emit("Idle")
	
func exit() -> void:
	player.animation_player.stop()
