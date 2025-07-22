class_name EnemyCharacter
extends CharacterBody2D

# Signal to notify state machine of damage
signal enemy_hurt_emitter

@onready var sprite: Sprite2D = $Sprite2D
@onready var enemy_collision_shape: CollisionShape2D = $CollisionShape2D
@onready var damage_emitter: Area2D = $DamageEmitter
@onready var enemy_damage_receiver: CollisionShape2D = $EnemyDamageReceiver/CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var damage_receiver: EnemyDamageReceiver = $EnemyDamageReceiver

@export var player: PlayerCharacter
@export var damage: int
@export var max_health: int
@export var jump_intensity: int
@export var speed: int

var current_health := 0
var enemy_sensor_position
var enemy_damage_sensor
var last_valid_direction: Vector2 = Vector2.RIGHT

func _ready() -> void:
	damage_receiver.enemy_damage_receiver.connect(on_receive_damage)
	enemy_sensor_position = enemy_collision_shape.position
	enemy_damage_sensor = enemy_damage_receiver.position
	current_health = max_health

func get_movement_direction() -> Vector2:
	var direction := Vector2.ZERO
	if player != null:
		direction = (player.position - position).normalized()
		
		if (player.position - position).length() < 30:
			direction = Vector2.ZERO
		else:
			last_valid_direction = direction
			
	return direction

func get_sprite_position(direction: Vector2) -> void:
	if direction.x > 0:
		sprite.flip_h = false
		damage_emitter.scale.x = 1
		enemy_collision_shape.position.x = enemy_sensor_position.x
		enemy_damage_receiver.position.x = enemy_damage_sensor.x
	elif direction.x < 0:
		sprite.flip_h = true
		damage_emitter.scale.x = -1
		enemy_collision_shape.position.x = -enemy_sensor_position.x
		enemy_damage_receiver.position.x = -enemy_damage_sensor.x

func on_receive_damage(_damage: int, _direction: Vector2) -> void:
	current_health = clamp(current_health - _damage, 0, max_health)
	print(current_health)
	if current_health <= 0:
		queue_free()
	else:
		enemy_hurt_emitter.emit()
