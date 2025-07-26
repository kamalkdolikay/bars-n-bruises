class_name EnemyCharacter
extends CharacterBody2D

# Nodes
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var damage_emitter: Area2D = $DamageEmitter
@onready var damage_receiver: EnemyDamageReceiver = $EnemyDamageReceiver
@onready var damage_shape: CollisionShape2D = $EnemyDamageReceiver/CollisionShape2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine := $StateMachine
@onready var collateral_emitter: Area2D = $CollateralDamageEmitter

# Exported Variables
@export var player: PlayerCharacter
@export var damage: int
@export var max_health: int
@export var jump_intensity: int
@export var speed: int
@export var max_slot_distance: float = 50.0
@export var slot_check_interval: float = 0.5
@export var flight_speed: float
@export var attack_cooldown: int
@export var duration_prep_hit: int

# State Definitions
enum State { IDLE, WALK, HURT1, HURT2, WAKEUP, FLY, FALL, ATTACK1, ATTACK2, ATTACK3 }
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
}
var attack_states := ["Attack1", "Attack2", "Attack3"]

# Internal Variables
var current_health: int = 0
var hit_type: EnemyDamageReceiver.HitType = EnemyDamageReceiver.HitType.NORMAL
var player_slot: EnemySlot = null
var slot_check_timer: float = 0.0
var last_attack_time: int = 0
var last_prep_time: int = 0

var initial_collision_position: Vector2
var initial_damage_position: Vector2

# Initialization
func _ready() -> void:
	# Connect signals
	damage_emitter.area_entered.connect(on_emit_damage)
	damage_receiver.enemy_damage_receiver.connect(on_receive_damage)
	collateral_emitter.area_entered.connect(on_emit_collateral_damage)
	collateral_emitter.body_entered.connect(on_wall_hit)
	
	# Init state
	initial_collision_position = collision_shape.position
	initial_damage_position = damage_shape.position
	current_health = max_health
	
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

# Animation
func play_animation(state: String) -> void:
	animation_player.play(state)

func stop_animation() -> void:
	animation_player.stop()

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

# Damage Logic
func on_receive_damage(damage_amount: int, _direction: Vector2, _hit_type: EnemyDamageReceiver.HitType) -> void:
	current_health = clamp(current_health - damage_amount, 0, max_health)
	
	# Free slot only on death
	if current_health == 0 and is_instance_valid(player_slot):
		player.free_slot(self)
		player_slot = null
	
	# Emit HURT2 for death or KNOCKDOWN, otherwise HURT1
	var state_to_emit
	if current_health == 0 or _hit_type == EnemyDamageReceiver.HitType.KNOCKDOWN:
		state_to_emit = states[State.HURT2]
	elif _hit_type == EnemyDamageReceiver.HitType.POWER:
		state_to_emit = states[State.HURT1]
		hit_type = EnemyDamageReceiver.HitType.POWER
	else:
		state_to_emit = states[State.HURT1]
		hit_type = EnemyDamageReceiver.HitType.NORMAL
	state_machine.on_state_transition(state_to_emit)

func is_dead() -> bool:
	return current_health <= 0

# Damage Emission
func on_emit_damage(target: Area2D) -> void:
	var direction := Vector2.LEFT if target.global_position.x < global_position.x else Vector2.RIGHT
	(target as PlayerDamageReceiver).player_damage_receiver.emit(damage, direction, EnemyDamageReceiver.HitType.NORMAL)

func on_emit_collateral_damage(target: EnemyDamageReceiver) -> void:
	var direction := Vector2.LEFT if target.global_position.x < global_position.x else Vector2.RIGHT
	target.enemy_damage_receiver.emit(0, direction, EnemyDamageReceiver.HitType.KNOCKDOWN)

func on_wall_hit(_wall: AnimatableBody2D) -> void:
	state_machine.on_state_transition(states[State.FALL])
