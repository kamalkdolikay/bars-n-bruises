extends Node2D

const STAGE_PREFABS := [
	preload("res://src/stage/stage_01/scene/stage_01.tscn"),
	preload("res://src/stage/stage_02/scene/stage_02.tscn")
]
const PLAYER_PREFAB := preload("res://src/features/characters/player/types/bancho_player/bancho_player.tscn")

#@onready var player: PlayerCharacter = $ActorsContainer/Player
@onready var camera: Camera2D = $Camera
@onready var stage_container: Node2D = $StageContainer
@onready var actors_container: Node2D = $ActorsContainer

var is_camera_locked: bool = false
var current_stage_index = -1
var camera_initial_position: Vector2 = Vector2.ZERO
var is_stage_ready_for_loading: bool = false
var player: PlayerCharacter = null

func _ready() -> void:
	camera_initial_position = camera.position
	StageManager.checkpoint_start.connect(on_checkpoint_start)
	StageManager.checkpoint_complete.connect(on_checkpoint_complete)
	StageManager.stage_complete.connect(load_next_stage)
	load_next_stage()

func _process(_delta: float) -> void:
	if is_stage_ready_for_loading:
		is_stage_ready_for_loading = false
		var stage = STAGE_PREFABS[current_stage_index].instantiate()
		stage_container.add_child(stage)
		player = PLAYER_PREFAB.instantiate()
		actors_container.add_child(player)
		player.position = stage.get_player_spawn_location()
		actors_container.player = player
		camera.position = camera_initial_position
	if player and not is_camera_locked and player.position.x > camera.position.x:
		camera.position.x = player.position.x

func on_checkpoint_start() -> void:
	is_camera_locked = true
	
func on_checkpoint_complete(_checkpoint: Checkpoint) -> void:
	is_camera_locked = false

func load_next_stage() -> void:
	current_stage_index += 1
	if current_stage_index < STAGE_PREFABS.size():
		for actor: Node2D in actors_container.get_children():
			actor.queue_free()
		
		for existing_stage in stage_container.get_children():
			existing_stage.queue_free()
		is_stage_ready_for_loading = true
