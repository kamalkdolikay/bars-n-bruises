class_name IdleState
extends CharacterState

@export var player: PlayerCharacter

func enter() -> void:
	player.animation_player.play("idle")
	
func update(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		transition.emit("Jump")
	elif player.get_movement_direction() != Vector2.ZERO:
		transition.emit("Walk")

func exit() -> void:
	player.animation_player.stop()
