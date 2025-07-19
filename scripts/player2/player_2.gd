class_name PlayerCharacter2
extends CharacterBody2D

@onready var damage_emitter: Area2D = $DamageEmitter

func _ready() -> void:
	damage_emitter.area_entered.connect(on_emit_damage)
	
func on_emit_damage(damage_receiver: PlayerDamageReceiver) -> void:
	damage_receiver.player_damage_receiver.emit()
