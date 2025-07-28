extends Node2D

@onready var player: PlayerCharacter = $ActorsContainer/Player
@onready var camera: Camera2D = $Camera

var is_camera_locked: bool = false

func _ready() -> void:
	StageManager.checkpoint_start.connect(on_checkpoint_start)
	StageManager.checkpoint_complete.connect(on_checkpoint_complete)

func _process(_delta: float) -> void:
	if player:
		if not is_camera_locked and player.position.x > camera.position.x:
			camera.position.x = player.position.x

func on_checkpoint_start() -> void:
	is_camera_locked = true
	
func on_checkpoint_complete() -> void:
	is_camera_locked = false
