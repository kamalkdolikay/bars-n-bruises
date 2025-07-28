class_name BossEnemy
extends BaseEnemy

# Attack Logic
func is_player_within_range() -> bool:
	return (player_slot.global_position - global_position).length() < 25
