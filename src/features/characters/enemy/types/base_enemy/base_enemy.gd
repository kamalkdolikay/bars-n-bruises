class_name BaseEnemy
extends BaseCharacter

# Nodes
@onready var state_machine: CharacterStateMachine = $StateMachine
@onready var collateral_emitter: Area2D = $CollateralDamageEmitter
@onready var collateral_shape: CollisionShape2D = $CollateralDamageEmitter/CollisionShape2D

# Exported Variables
@export var player: PlayerCharacter
@export var jump_intensity: int
@export var max_slot_distance: float = 50.0
@export var slot_check_interval: float = 0.5
@export var flight_speed: float
@export var attack_cooldown: int
@export var duration_prep_hit: int

# State Definitions
enum State { IDLE, WALK, HURT1, HURT2, WAKEUP, FLY, FALL, ATTACK1, ATTACK2, ATTACK3, LAND1, LAND2, WAIT }
var states := {
	State.IDLE: "Idle",
	State.WALK: "Walk",
	State.HURT1: "Hurt1",
	State.HURT2: "Hurt2",
	State.WAKEUP: "Wakeup",
	State.FLY: "Fly",
	State.FALL: "Fall",
	State.ATTACK1: "Attack1",
	State.ATTACK2: "Attack2",
	State.ATTACK3: "Attack3",
	State.LAND1: "Land1",
	State.LAND2: "Land2",
	State.WAIT: "Wait",
}
var attack_states := ["Attack1", "Attack2", "Attack3"]

# Internal Variables
var player_slot: EnemySlot = null
var slot_check_timer: float = 0.0
var last_attack_time: int = 0
var last_prep_time: int = 0
var initial_collateral_position: Vector2
var ground_position: float = 0.0
var assigned_door_index: int = -1
var door: Door
var is_hit_once: bool = false

# Initialization
func _ready() -> void:
	super._ready()
	# Connect signals
	collateral_emitter.area_entered.connect(on_emit_collateral_damage)
	# Init state
	initial_collateral_position = collateral_shape.position
	# Attempt initial slot reservation
	if player and not player_slot:
		player_slot = player.reserve_slot(self)

# Frame Loop
func _process(delta: float) -> void:
	# Update slot check timer
	slot_check_timer += delta
	if slot_check_timer >= slot_check_interval:
		update_slot()
		slot_check_timer = 0.0
	
	handle_prep_attack()
	handle_attack_logic()
	
	# Reattempt slot reservation if no slot is assigned and player exists
	if player and not player_slot:
		player_slot = player.reserve_slot(self)

# Slot Management
func update_slot() -> void:
	if player and player_slot and is_instance_valid(player_slot):
		if global_position.distance_to(player_slot.global_position) <= max_slot_distance:
			return
		player.free_slot(self)
		# Reserve the nearest available slot
		player_slot = player.reserve_slot(self)

# Movement & Facing
func get_movement_direction() -> Vector2:
	if player_slot and is_instance_valid(player_slot):
		if is_player_within_range():
			return Vector2.ZERO
		return (player_slot.global_position - global_position).normalized()
	# No slot available or slot is invalid, idle
	return Vector2.ZERO

func get_facing_direction() -> Vector2:
	if player and is_instance_valid(player):
		return (player.global_position - global_position).normalized()
	return Vector2.RIGHT  # Default direction if player is invalid

func get_sprite_position() -> void:
	var direction := get_facing_direction()
	var flip = -1 if direction.x < 0 else 1
	
	sprite.flip_h = direction.x < 0
	damage_emitter.scale.x = flip
	collision_shape.position.x = initial_collision_position.x * flip
	damage_shape.position.x = initial_damage_position.x * flip
	collateral_shape.position.x = initial_collateral_position.x * flip

func get_knockback_direction() -> Vector2:
	return Vector2.RIGHT if get_facing_direction().x < 0 else Vector2.LEFT

# Attack Logic
func handle_attack_logic() -> void:
	if not can_attack(): return
	var attack = attack_states[randi() % attack_states.size()]
	if player and player_slot and is_instance_valid(player_slot) and is_player_within_range():
		if state_machine.current_state.name != attack:
			last_prep_time = Time.get_ticks_msec()
			state_machine.on_state_transition(attack)

func handle_prep_attack() -> void:
	var now := Time.get_ticks_msec()
	var is_attacking = state_machine.current_state.name in attack_states
	if is_attacking and (now - last_prep_time > duration_prep_hit) and (now - last_attack_time > attack_cooldown):
		var next_attack = attack_states[randi() % attack_states.size()]
		if state_machine.current_state.name != next_attack:
			state_machine.on_state_transition(next_attack)
			last_attack_time = now

func can_attack() -> bool:
	var now := Time.get_ticks_msec()
	return now - last_attack_time > attack_cooldown \
		and state_machine.current_state.name in ["Idle", "Walk"]

func is_player_within_range() -> bool:
	return (player_slot.global_position - global_position).length() < 1

# Damage Emission
func _on_emit_damage(target: Area2D) -> void:
	var direction := Vector2.LEFT if get_facing_direction().x < 0 else Vector2.RIGHT
	target.emit_damage(damage, direction, DamageReceiver.HitType.NORMAL)

func on_emit_collateral_damage(target: DamageReceiver) -> void:
	var direction := Vector2.LEFT if get_facing_direction().x < 0 else Vector2.RIGHT
	target.emit_damage(0, direction, DamageReceiver.HitType.KNOCKDOWN)
