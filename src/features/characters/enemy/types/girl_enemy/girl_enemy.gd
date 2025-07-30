class_name GirlEnemy
extends BaseEnemy

func _ready() -> void:
	super._ready()
	set_health(max_health, is_hit_once)

# Damage Logic
func _on_receive_damage(damage_amount: int, _direction: Vector2, _hit_type: DamageReceiver.HitType) -> void:
	set_health(current_health - damage_amount, true)
	
	# Free slot only on death
	if is_dead() and is_instance_valid(player_slot):
		player.free_slot(self)
		player_slot = null
	
	# Emit HURT2 for death or KNOCKDOWN, otherwise HURT1
	var state_to_emit
	if is_dead() or _hit_type == DamageReceiver.HitType.KNOCKDOWN:
		state_to_emit = states[State.HURT2]
	elif _hit_type == DamageReceiver.HitType.POWER:
		state_to_emit = states[State.HURT1]
		hit_type = DamageReceiver.HitType.POWER
	else:
		state_to_emit = states[State.HURT1]
		hit_type = DamageReceiver.HitType.NORMAL
	state_machine.on_state_transition(state_to_emit)

# UI
func set_health(health: int, is_hit: bool) -> void:
	current_health = clamp(health, 0, max_health)
	if is_hit:
		DamageManager.health_change.emit(Type.GIRL, current_health, max_health)
