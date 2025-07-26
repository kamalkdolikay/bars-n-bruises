class_name EnemyDamageReceiver
extends Area2D

enum HitType { NORMAL, KNOCKDOWN, POWER }

@warning_ignore("unused_signal")
signal enemy_damage_receiver(damage: int, direction: Vector2, hit_type: HitType)
