class_name EnemyData
extends Resource

const DROP_HEIGHT: int = 260

@export var type: BaseCharacter.Type
@export var global_position: Vector2
@export var height: int

func _init(character_type: BaseCharacter.Type = BaseCharacter.Type.GIRL, position: Vector2 = Vector2.ZERO) -> void:
	type = character_type
	if position.y < 0:
		height = DROP_HEIGHT
		global_position = position + Vector2.DOWN * DROP_HEIGHT
	else:
		global_position = position
