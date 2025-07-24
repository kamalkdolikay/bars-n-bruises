class_name EnemyAttack1
extends CharacterState

@export var enemy: EnemyCharacter
@onready var damage_emitter: Area2D = $"../../DamageEmitter"

func enter() -> void:
	enemy.animation_player.play("attack1")
	damage_emitter.monitoring = true
	
func update(_delta: float) -> void:
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack1":
		transition.emit("Idle")

func exit() -> void:
	enemy.animation_player.stop()
	damage_emitter.monitoring = false
