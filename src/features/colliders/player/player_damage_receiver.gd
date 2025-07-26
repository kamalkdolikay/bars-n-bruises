class_name PlayerDamageReceiver
extends DamageReceiver
#
#enum HitType { PUNCH, KICK, KNOCKDOWN }
#
#signal player_damage_receiver(damage: int, direction: Vector2, hit_type: HitType)
#
#func emit_damage(damage: int, direction: Vector2, hit_type: HitType) -> void:
	#player_damage_receiver.emit(damage, direction, hit_type)
