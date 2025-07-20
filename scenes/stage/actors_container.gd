# actors_container.gd
# Description: Manages the spawning of actor nodes, such as collectibles, within the game world.
# Author: [Your Name]
# Last Modified: 2025-07-19

extends Node2D

# Constants
const CHICKEN_PREFAB := preload("res://scenes/props/chicken.tscn")

# Signals and Connections
func _ready() -> void:
	EntityManager.spawn_collecible.connect(on_spawn_collectible)

# Public Methods
# on_spawn_collectible: Handles the spawning of a collectible at the given global position.
# @param collectible_global_position: The global position where the collectible should spawn.
func on_spawn_collectible(collectible_global_position: Vector2) -> void:
	call_deferred("_deferred_spawn_collectible", collectible_global_position)

# Private Methods
# _deferred_spawn_collectible: Deferred method to instantiate and add a chicken collectible to the scene.
# @param collectible_global_position: The global position where the collectible should spawn.
func _deferred_spawn_collectible(collectible_global_position: Vector2) -> void:
	var chicken := CHICKEN_PREFAB.instantiate()
	chicken.state = Collectible.State.FALL  # Use enum from Collectible class
	chicken.global_position = collectible_global_position
	add_child(chicken)
