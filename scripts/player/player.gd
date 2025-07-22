class_name PlayerCharacter
extends CharacterBody2D

# Signal to notify state machine of damage
signal hurt_emitter

@onready var player: PlayerCharacter = $"."
@onready var damage_emitter: Area2D = $DamageEmitter
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var damage_receiver: PlayerDamageReceiver = $DamageReceiver
@onready var collectible_sensor: Area2D = $CollectibleSensor
@onready var player_collision_shape: CollisionShape2D = $CollisionShape2D
@onready var collectible_collision_shape: CollisionShape2D = $CollectibleSensor/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var player_damage_receiver: CollisionShape2D = $DamageReceiver/CollisionShape2D


@export var move_speed: float = 50.0
@export var input_transitions: Dictionary = {
	"ui_accept": "Jump",
	"attack1": "Attack1",
	"attack2": "Attack2",
	"attack3": "Attack3",
}
@export var damage: int
@export var max_health: int
@export var speed: int

var player_sensor_position
var collectible_sensor_position
var player_damage_sensor

func _ready() -> void:
	damage_emitter.area_entered.connect(on_emit_damage)
	damage_receiver.player_damage_receiver.connect(on_receive_damage)
	collectible_sensor.area_entered.connect(on_collectible_entered)
	player_sensor_position = player_collision_shape.position
	collectible_sensor_position = collectible_collision_shape.position
	player_damage_sensor = player_damage_receiver.position

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
		sprite.flip_h = false
		damage_emitter.scale.x = 1
		player_collision_shape.position.x = player_sensor_position.x
		collectible_collision_shape.position.x = collectible_sensor_position.x
		player_damage_receiver.position.x = player_damage_sensor.x
	elif direction.x < 0:
		sprite.flip_h = true
		damage_emitter.scale.x = -1
		player_collision_shape.position.x = -player_sensor_position.x
		collectible_collision_shape.position.x = -collectible_sensor_position.x
		player_damage_receiver.position.x = -player_damage_sensor.x

func on_collectible_entered(collectible: Area2D) -> void:
	collectible.queue_free()

func on_emit_damage(_damage_receiver: Area2D) -> void:
	if _damage_receiver is DamageReceiver:
		var direction := Vector2.LEFT if _damage_receiver.global_position.x < global_position.x else Vector2.RIGHT
		(_damage_receiver as DamageReceiver).barrel_damage_receiver.emit(direction)
	elif _damage_receiver is EnemyDamageReceiver:
		var direction := Vector2.LEFT if _damage_receiver.global_position.x < global_position.x else Vector2.RIGHT
		(_damage_receiver as EnemyDamageReceiver).enemy_damage_receiver.emit(damage, direction)
	
func on_receive_damage() -> void:
	hurt_emitter.emit()
