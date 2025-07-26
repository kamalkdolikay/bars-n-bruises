class_name EnemyAttack1
extends CharacterState

@export var enemy: EnemyCharacter
@onready var damage_emitter: Area2D = $"../../DamageEmitter"

func enter() -> void:
	enemy.play_animation((enemy.states[enemy.State.ATTACK1]).to_lower())
	damage_emitter.monitoring = true
	
func update(_delta: float) -> void:
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == (enemy.states[enemy.State.ATTACK1]).to_lower():
		transition.emit(enemy.states[enemy.State.IDLE])

func exit() -> void:
	enemy.stop_animation()
	damage_emitter.monitoring = false
