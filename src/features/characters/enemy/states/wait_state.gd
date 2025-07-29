class_name EnemyWaitState
extends CharacterState

@export var enemy: BaseEnemy

var initial_z_index: int

func enter() -> void:
	enemy.play_animation("idle")
	initial_z_index = enemy.door.sprite.z_index
	
func update(_delta: float) -> void:
	if enemy.door.state == Door.State.CLOSED:
		enemy.door.sprite.z_index = 1
		enemy.door.open()
	if enemy.door.state == Door.State.OPENED:
		enemy.door.sprite.z_index = initial_z_index
		await get_tree().create_timer(0.3).timeout
		transition.emit("Idle")

func exit() -> void:
	enemy.stop_animation()
