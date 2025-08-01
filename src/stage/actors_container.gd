# actors_container.gd
# Description: Manages the spawning of actor nodes, such as collectibles, within the game world.
# Author: Kamal Dolikay
# Last Modified: 2025-07-27

extends Node2D

@export var player: PlayerCharacter

# Constants
const COLLECTIBLE_MAP := {
	Collectible.Type.FOOD1: preload("res://src/features/props/food/chicken_1/chicken_1.tscn"),
	Collectible.Type.FOOD2: preload("res://src/features/props/food/chicken_2/chicken_2.tscn"),
	Collectible.Type.FOOD3: preload("res://src/features/props/food/chicken_3/chicken_3.tscn"),
}

const ENEMY_MAP := {
	BaseCharacter.Type.GIRL: preload("res://src/features/characters/enemy/types/girl_enemy/girl_enemy.tscn"),
	BaseCharacter.Type.BOSS: preload("res://src/features/characters/enemy/types/boss_enemy/boss_enemy.tscn"),
}

const SPARK_PREFAB := preload("res://src/features/particles/spark.tscn")

var doors: Array[Door] = []

# Signals and Connections
func _init() -> void:
	EntityManager.spawn_collecible.connect(on_spawn_collectible)
	EntityManager.spawn_enemy.connect(on_spawn_enemy)
	EntityManager.orphan_actor.connect(on_orphan_actor)
	EntityManager.spawn_spark.connect(on_spawn_spark)
	DamageManager.player_revive.connect(on_player_revive)

# Public Methods
# on_spawn_collectible: Handles the spawning of a collectible at the given global position.
# @param collectible_global_position: The global position where the collectible should spawn.
func on_spawn_collectible(collectible_global_position: Vector2, collectible_type: Collectible.Type) -> void:
	call_deferred("_deferred_spawn_collectible", collectible_global_position, collectible_type)

# Private Methods
# _deferred_spawn_collectible: Deferred method to instantiate and add a chicken collectible to the scene.
# @param collectible_global_position: The global position where the collectible should spawn.
func _deferred_spawn_collectible(collectible_global_position: Vector2, collectible_type: Collectible.Type) -> void:
	var collectible: Collectible = COLLECTIBLE_MAP[collectible_type].instantiate()
	collectible.state = Collectible.State.FALL  # Use enum from Collectible class
	collectible.global_position = collectible_global_position
	add_child(collectible)
	
func on_spawn_enemy(enemy_data: EnemyData) -> void:
	var enemy: BaseEnemy = ENEMY_MAP[enemy_data.type].instantiate()
	enemy.global_position = enemy_data.global_position
	enemy.player = player
	enemy.ground_position = enemy_data.global_position.y
	add_child(enemy)
	
	if enemy_data.height > 0:
		enemy.state_machine.on_state_transition("Land1")
	if enemy_data.door_index > -1:
		enemy.door = doors[enemy_data.door_index]
		enemy.state_machine.on_state_transition("Wait")

func on_spawn_spark(spark_position: Vector2) -> void:
	var spark_instance := SPARK_PREFAB.instantiate()
	spark_instance.position = spark_position
	add_child(spark_instance)

func on_orphan_actor(orphan: Node2D) -> void:
	if orphan is Door:
		doors.append(orphan)
	orphan.reparent(self)

func on_player_revive() -> void:
	for child in get_children():
		if child is BaseCharacter:
			var character: BaseCharacter = child as BaseCharacter
			if character.type != BaseCharacter.Type.PLAYER:
				character._on_receive_damage(0, Vector2.ZERO, DamageReceiver.HitType.KNOCKDOWN)
