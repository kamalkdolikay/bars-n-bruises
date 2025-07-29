class_name EnemyWaitState
extends CharacterState

@export var enemy: BaseEnemy

const DURATION_APPEAR := 2000  # milliseconds
var initial_z_index: int
var time_start_appearing: int = 0

func enter() -> void:
	enemy.play_animation((enemy.states[enemy.State.IDLE]).to_lower())
	initial_z_index = enemy.door.sprite.z_index
	enemy.modulate.a = 0.0
	time_start_appearing = Time.get_ticks_msec()
	
	if enemy.door.state == Door.State.CLOSED:
		enemy.door.sprite.z_index = 1  # bring door in front
		enemy.door.open()

func update(_delta: float) -> void:
	var door_state := enemy.door.state

	if door_state == Door.State.OPENING or door_state == Door.State.OPENED:
		var time_elapsed := Time.get_ticks_msec() - time_start_appearing
		var progress = clamp(float(time_elapsed) / DURATION_APPEAR, 0.0, 1.0)
		enemy.modulate.a = progress

		if door_state == Door.State.OPENED and progress >= 1.0:
			enemy.door.sprite.z_index = initial_z_index
			await get_tree().create_timer(0.3).timeout
			transition.emit(enemy.states[enemy.State.IDLE])

func exit() -> void:
	enemy.stop_animation()
