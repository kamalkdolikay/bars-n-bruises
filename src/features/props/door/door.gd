class_name Door
extends Node2D

signal open_door

@onready var sprite: Sprite2D = $DoorSprite
@export var duration_open: float
@export var enemies: Array[BaseEnemy]

enum State { CLOSED, OPENING, OPENED }

var door_height: int = 0
var state: State = State.CLOSED
var time_start_opening := Time.get_ticks_msec()

func _ready() -> void:
	door_height = sprite.texture.get_height() - 294
	
func _process(_delta: float) -> void:
	if state == State.OPENING:
		var now := Time.get_ticks_msec()
		if now - time_start_opening > duration_open:
			state = State.OPENED
			sprite.position = Vector2.UP * door_height
			open_door.emit()
		else:
			var progress := (now - time_start_opening) / duration_open
			sprite.position = lerp(Vector2.ZERO, Vector2.UP * door_height, progress)

func open() -> void:
	if state == State.CLOSED:
		state = State.OPENING
		time_start_opening = Time.get_ticks_msec()
