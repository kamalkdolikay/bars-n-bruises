class_name PlayerCharacter
extends CharacterBody2D

# Nodes
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collectible_collision_shape: CollisionShape2D = $CollectibleSensor/CollisionShape2D
@onready var collectible_sensor: Area2D = $CollectibleSensor
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var damage_emitter: Area2D = $DamageEmitter
@onready var damage_receiver: PlayerDamageReceiver = $DamageReceiver
@onready var damage_shape: CollisionShape2D = $DamageReceiver/CollisionShape2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var state_machine: CharacterStateMachine = $StateMachine
@onready var enemy_slots: Array = $EnemySlots.get_children()

# Exported Variables
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

# State Definitions
enum State { IDLE, WALK, JUMP, ATTACK1, ATTACK2, ATTACK3, HURT1, HURT2, WAKEUP }
var states := {
	State.IDLE: "Idle",
	State.WALK: "Walk",
	State.JUMP: "Jump",
	State.ATTACK1: "Attack1",
	State.ATTACK2: "Attack2",
	State.ATTACK3: "Attack3",
	State.HURT1: "Hurt1",
	State.HURT2: "Hurt2",
	State.WAKEUP: "Wakeup",
}

# Internal Variables
var current_health := 0
var initial_collectible_position: Vector2
var initial_collision_position: Vector2
var initial_damage_position: Vector2
var hit_type: PlayerDamageReceiver.HitType
var knockback_direction: Vector2 = Vector2.ZERO

# Initialization
func _ready() -> void:
	# Connect signals
	damage_emitter.area_entered.connect(on_emit_damage)
	damage_receiver.player_damage_receiver.connect(on_receive_damage)
	collectible_sensor.area_entered.connect(on_collectible_entered)
	
	# Init state
	current_health = max_health
	initial_collision_position = collision_shape.position
	initial_collectible_position = collectible_collision_shape.position
	initial_damage_position = damage_shape.position

# Movement & Facing
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
		collision_shape.position.x = initial_collision_position.x
		collectible_collision_shape.position.x = initial_collectible_position.x
		damage_shape.position.x = initial_damage_position.x
	elif direction.x < 0:
		sprite.flip_h = true
		damage_emitter.scale.x = -1
		collision_shape.position.x = -initial_collision_position.x
		collectible_collision_shape.position.x = -initial_collectible_position.x
		damage_shape.position.x = -initial_damage_position.x

func get_knockback_direction() -> Vector2:
	return knockback_direction

# Collectibles
func on_collectible_entered(collectible: Area2D) -> void:
	collectible.queue_free()

# Animation
func play_animation(state: String) -> void:
	animation_player.play(state)

func stop_animation() -> void:
	animation_player.stop()

# Damage Logic
func on_receive_damage(damage_amount: int, direction: Vector2, _hit_type: PlayerDamageReceiver.HitType) -> void:
	current_health = clamp(current_health - damage_amount, 0, max_health)
	var state_to_emit
	knockback_direction = direction.normalized()
	
	if current_health == 0 or _hit_type == PlayerDamageReceiver.HitType.KNOCKDOWN:
		state_to_emit = "Hurt2"
	elif _hit_type == PlayerDamageReceiver.HitType.PUNCH:
		state_to_emit = "Hurt1"
		hit_type = PlayerDamageReceiver.HitType.KICK
	else:
		state_to_emit = "Hurt1"
		hit_type = PlayerDamageReceiver.HitType.PUNCH
	state_machine.on_state_transition(state_to_emit)

func is_dead() -> bool:
	return current_health <= 0

# Damage Emission
func on_emit_damage(receiver: Area2D) -> void:
	var attack_name := state_machine.current_state.name
	var attack_props = _get_attack_properties(attack_name)
	var _hit_type = attack_props[0]
	var calculated_damage = attack_props[1]
	
	var hit_dir := _get_hit_direction(receiver)
	
	if receiver is DamageReceiver:
		receiver.barrel_damage_receiver.emit(hit_dir)
	elif receiver is EnemyDamageReceiver:
		receiver.enemy_damage_receiver.emit(calculated_damage, hit_dir, _hit_type)

func _get_attack_properties(state_name: String) -> Array:
	match state_name:
		"Attack3":
			return [EnemyDamageReceiver.HitType.KNOCKDOWN, 6]
		"Attack2":
			return [EnemyDamageReceiver.HitType.POWER, 8]
		_:
			return [EnemyDamageReceiver.HitType.NORMAL, damage]

func _get_hit_direction(target: Node2D) -> Vector2:
	return Vector2.LEFT if target.global_position.x < global_position.x else Vector2.RIGHT

# Slot Management
func reserve_slot(enemy: EnemyCharacter) -> EnemySlot:
	var available_slots: Array = enemy_slots.filter(
		func(slot: EnemySlot) -> bool:
			return slot.is_free()
	)
	if available_slots.is_empty():
		return null
	
	available_slots.sort_custom(
		func(a: EnemySlot, b: EnemySlot):
			var dist_a := (enemy.global_position - a.global_position).length()
			var dist_b := (enemy.global_position - b.global_position).length()
			return dist_a < dist_b
	)
	
	var selected_slot: EnemySlot = available_slots[0]
	selected_slot.occupy(enemy)
	return selected_slot

func free_slot(enemy: EnemyCharacter) -> void:
	for slot in enemy_slots:
		if slot.occupant == enemy:
			slot.free_up()
			return
