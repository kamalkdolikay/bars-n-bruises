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
var player_slot: EnemySlot = null

func _ready() -> void:
	damage_receiver.enemy_damage_receiver.connect(on_receive_damage)
	enemy_sensor_position = enemy_collision_shape.position
	enemy_damage_sensor = enemy_damage_receiver.position
	current_health = max_health
	# Attempt initial slot reservation
	if player != null and player_slot == null:
		player_slot = player.reserve_slot(self)

func _process(_delta: float) -> void:
	# Reattempt slot reservation if no slot is assigned and player exists
	if player != null and player_slot == null:
		player_slot = player.reserve_slot(self)

func get_movement_direction() -> Vector2:
	var direction := Vector2.ZERO
	if player != null:
		# Check if a slot is assigned
		if player_slot != null and is_instance_valid(player_slot):
			direction = (player_slot.global_position - global_position).normalized()
			if (player_slot.global_position - global_position).length() < 1:
				direction = Vector2.ZERO
		else:
			# No slot available or slot is invalid, idle instead of following player
			direction = Vector2.ZERO
	
	return direction

func get_facing_direction() -> Vector2:
	if player != null and is_instance_valid(player):
		return (player.global_position - global_position).normalized()
	return Vector2.RIGHT  # Default direction if player is invalid

func get_sprite_position(direction: Vector2) -> void:
	var facing_direction := get_facing_direction()
	if facing_direction.x > 0:
		sprite.flip_h = false
		damage_emitter.scale.x = 1
		enemy_collision_shape.position.x = enemy_sensor_position.x
		enemy_damage_receiver.position.x = enemy_damage_sensor.x
	elif facing_direction.x < 0:
		sprite.flip_h = true
		damage_emitter.scale.x = -1
		enemy_collision_shape.position.x = -enemy_sensor_position.x
		enemy_damage_receiver.position.x = -enemy_damage_sensor.x

func on_receive_damage(_damage: int, _direction: Vector2) -> void:
	current_health = clamp(current_health - _damage, 0, max_health)
	if current_health <= 0:
		player.free_slot(self)
		queue_free()
	else:
		enemy_hurt_emitter.emit()
		
