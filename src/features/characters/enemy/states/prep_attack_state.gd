class_name EnemyPrepAttackState
extends CharacterState

@export var enemy: EnemyCharacter

func enter() -> void:
	enemy.play_animation("prep_attack")
	
func update(_delta: float) -> void:
	pass

func exit() -> void:
	enemy.astop_animation()
