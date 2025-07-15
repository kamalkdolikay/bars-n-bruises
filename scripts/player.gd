class_name Player
extends CharacterBody2D

func _process(delta: float) -> void:
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
		
	velocity = direction * 70
	move_and_slide()
