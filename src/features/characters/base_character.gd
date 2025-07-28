class_name BaseCharacter
extends CharacterBody2D

# Nodes
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var damage_emitter: Area2D = $DamageEmitter
@onready var damage_receiver: DamageReceiver = $DamageReceiver
@onready var damage_shape: CollisionShape2D = $DamageReceiver/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D

# Exported Variables
@export var damage: int
@export var max_health: int
@export var speed: int
@export var type: Type

enum Type { PLAYER, GIRL, BOSS }

# Internal Variables
var current_health := 0
var initial_collision_position: Vector2
var initial_damage_position: Vector2
var hit_type: DamageReceiver.HitType = DamageReceiver.HitType.NORMAL

# Initialization
func _ready() -> void:
	# Connect signals
	damage_emitter.area_entered.connect(_on_emit_damage)
	damage_receiver.damage_received.connect(_on_receive_damage)
	
	# Init state
	current_health = max_health
	initial_collision_position = collision_shape.position
	initial_damage_position = damage_shape.position

# Movement & Facing
func get_movement_direction() -> Vector2:
	return Vector2.ZERO

# Animation
func play_animation(state: String) -> void:
	animation_player.play(state)

func stop_animation() -> void:
	animation_player.stop()

# Damage Emission
func _on_emit_damage(_receiver: Area2D) -> void:
	pass

# Damage Logic
func _on_receive_damage(damage_amount: int, _direction: Vector2, _received_hit_type: int) -> void:
	current_health = clamp(current_health - damage_amount, 0, max_health)

func is_dead() -> bool:
	return current_health <= 0
