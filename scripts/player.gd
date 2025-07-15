class_name Player
extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

func _process(delta: float) -> void:
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
		sprite_2d.flip_h = true
		animation_player.play("walk")
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		sprite_2d.flip_h = false
		animation_player.play("walk")
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
		animation_player.play("walk")
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
		animation_player.play("walk")
	
	if direction == Vector2.ZERO:
		animation_player.play("idle")
		
	velocity = direction * 50
	move_and_slide()
