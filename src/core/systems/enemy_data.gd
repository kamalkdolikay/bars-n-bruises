class_name EnemyData
extends Resource

@export var type: BaseCharacter.Type
@export var global_position: Vector2

func _init(character_type: BaseCharacter.Type = BaseCharacter.Type.GIRL, position: Vector2 = Vector2.ZERO) -> void:
	type = character_type
	global_position = position
