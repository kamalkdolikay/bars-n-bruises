class_name Checkpoint
extends Node2D

@export var max_simulataneous_enemies: int

@onready var enemies: Node2D = $Enemies
@onready var player_detection_area: Area2D = $PlayerDetectionArea

var active_enemy_count: int = 0
var enemy_data_queue: Array[EnemyData] = []
var is_checkpoint_active: bool = false

# Lifecycle Methods
func _ready() -> void:
	player_detection_area.body_entered.connect(on_player_enter)
	EntityManager.death_enemy.connect(on_enemy_death)
	initialize_enemy_data()

func _process(_delta: float) -> void:
	if is_checkpoint_active and can_spawn_enemies():
		spawn_next_enemy()

# Private Methods
func initialize_enemy_data() -> void:
	for enemy: BaseCharacter in enemies.get_children():
		enemy_data_queue.append(EnemyData.new(enemy.type, enemy.global_position))
		enemy.queue_free()

func can_spawn_enemies() -> bool:
	return not enemy_data_queue.is_empty() and active_enemy_count < max_simulataneous_enemies

func spawn_next_enemy() -> void:
	var enemy_data: EnemyData = enemy_data_queue.pop_front()
	if enemy_data:
		EntityManager.spawn_enemy.emit(enemy_data)
		active_enemy_count += 1

# Signal Handlers
func on_player_enter(_player: PlayerCharacter) -> void:
	if not is_checkpoint_active:
		StageManager.checkpoint_start.emit()
		active_enemy_count = 0
		is_checkpoint_active = true

func on_enemy_death(_enemy: BaseEnemy) -> void:
	active_enemy_count = max(0, active_enemy_count - 1)
	if active_enemy_count == 0 and enemy_data_queue.is_empty():
		StageManager.checkpoint_complete.emit()
		queue_free()
