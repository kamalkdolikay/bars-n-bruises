class_name WalkState
extends CharacterState

@export var player: PlayerCharacter

func enter() -> void:
	player.animation_player.play("walk")

func update(_delta: float):
	var direction := player.get_movement_direction()
	
	# Update sprite flip
	if direction.x > 0:
		player.sprite.flip_h = false
	elif direction.x < 0:
		player.sprite.flip_h = true
	
	# Apply movement
	player.velocity = direction.normalized() * player.move_speed
	player.move_and_slide()
	
	# Transition to Idle if no effective movement
	if direction == Vector2.ZERO:
		transition.emit("Idle")

func exit() -> void:
	player.animation_player.stop()
