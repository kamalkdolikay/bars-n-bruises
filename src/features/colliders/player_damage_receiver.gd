class_name PlayerDamageReceiver
extends Area2D

enum HitType { PUNCH, KICK, KNOCKDOWN }

@warning_ignore("unused_signal")
signal player_damage_receiver(damage: int, direction: Vector2, hit_type: HitType)
