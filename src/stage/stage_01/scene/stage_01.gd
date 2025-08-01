class_name Stage01
extends Node2D

@onready var containers: Node2D = $Containers
@onready var doors: Node2D = $Doors
@onready var checkpoints: Node2D = $Checkpoints
@onready var next_stage: Area2D = $NextStage

@export var music: MusicManager.Music

func _ready() -> void:
	next_stage.body_entered.connect(on_player_enter)
	for container: Node2D in containers.get_children():
		EntityManager.orphan_actor.emit(container)
		
	for i in range(doors.get_child_count()):
		var door: Door = doors.get_child(i)
		for enemy: BaseEnemy in door.enemies:
			enemy.assigned_door_index = i

	for door: Node2D in doors.get_children():
		EntityManager.orphan_actor.emit(door)

	for checkpoint: Checkpoint in checkpoints.get_children():
		checkpoint.initialize_enemy_data()

	MusicPlayer.play(music)

func on_player_enter(player) -> void:
	print(player)
