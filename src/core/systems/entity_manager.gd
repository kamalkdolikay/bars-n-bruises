extends Node

@warning_ignore("unused_signal")
signal spawn_collecible(collectible_global_position: Vector2, collectible_type: Collectible.Type)
@warning_ignore("unused_signal")
signal spawn_enemy(enemy_data: EnemyData)
@warning_ignore("unused_signal")
signal death_enemy(enemy: BaseEnemy)
@warning_ignore("unused_signal")
signal orphan_actor(orphan: Node2D)
