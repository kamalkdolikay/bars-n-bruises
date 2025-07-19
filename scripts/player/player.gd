class_name PlayerCharacter
extends CharacterBody2D

# Signal to notify state machine of damage
signal hurt_emitter

@onready var player: PlayerCharacter = $"."
@onready var damage_emitter: Area2D = $DamageEmitter
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var damage_receiver: PlayerDamageReceiver = $DamageReceiver

@export var sprite: Sprite2D
@export var move_speed: float = 50.0
@export var input_transitions: Dictionary = {
	"ui_accept": "Jump",
	"attack1": "Attack1",
	"attack2": "Attack2",
	"attack3": "Attack3",
}

func _ready() -> void:
	damage_emitter.area_entered.connect(on_emit_damage)
	damage_receiver.player_damage_receiver.connect(on_receive_damage)

func get_movement_direction() -> Vector2:
	var direction := Vector2.ZERO
	if Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
		direction.x = 1
	elif Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"):
		direction.x = -1
	if Input.is_action_pressed("ui_up"):
		direction.y = -1
	if Input.is_action_pressed("ui_down"):
		direction.y = 1
	return direction
	
func get_sprite_position(direction: Vector2) -> void:
	if direction.x > 0:
		player.sprite.flip_h = false
		damage_emitter.scale.x = 1
	elif direction.x < 0:
		player.sprite.flip_h = true
		damage_emitter.scale.x = -1

func on_emit_damage(_damage_receiver: DamageReceiver) -> void:
	var direction := Vector2.LEFT if _damage_receiver.global_position.x < global_position.x else Vector2.RIGHT
	_damage_receiver.barrel_damage_receiver.emit(direction)
	
func on_receive_damage() -> void:
	hurt_emitter.emit()  # Emit signal to state machine
