class_name DamageReceiver
extends Area2D

enum HitType { PUNCH, KICK, KNOCKDOWN, NORMAL, POWER }

signal damage_received(damage: int, direction: Vector2, hit_type: HitType)

func emit_damage(damage: int, direction: Vector2, hit_type: HitType) -> void:
	damage_received.emit(damage, direction, hit_type)
