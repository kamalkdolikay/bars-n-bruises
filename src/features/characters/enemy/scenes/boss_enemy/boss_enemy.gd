class_name BossEnemy
extends BaseEnemy

# Nodes
@onready var collateral_emitter: Area2D = $CollateralDamageEmitter

# Initialization
func _ready() -> void:
	## Initialize enemy-specific properties and connections.
	super._ready()
	# Connect signals
	collateral_emitter.area_entered.connect(on_emit_collateral_damage)
	
	# Attempt initial slot reservation
	if player and not player_slot:
		player_slot = player.reserve_slot(self)

# Attack Logic
func is_player_within_range() -> bool:
	return (player_slot.global_position - global_position).length() < 25

# Damage Emission
func on_emit_collateral_damage(target: DamageReceiver) -> void:
	var direction := Vector2.LEFT if get_facing_direction().x < 0 else Vector2.RIGHT
	target.emit_damage(0, direction, DamageReceiver.HitType.KNOCKDOWN)
