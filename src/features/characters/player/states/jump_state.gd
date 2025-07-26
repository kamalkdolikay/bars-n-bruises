class_name JumpState
extends CharacterState

const GRAVITY := 600.0

@export var player: PlayerCharacter
@export var jump_intensity: float

enum LocalState { TAKEOFF, JUMP, LAND }

const ANIMATIONS := {
	LocalState.TAKEOFF: "takeoff",
	LocalState.JUMP: "jump",
	LocalState.LAND: "land"
}

var state = null
var height: float = 0.0
var height_speed: float = 0.0
var initial_y: float = 0.0

func enter() -> void:
	player.play_animation(ANIMATIONS[LocalState.TAKEOFF])
	initial_y = player.position.y

func update(delta: float) -> void:
	if state != null:
		player.play_animation(ANIMATIONS[state])

	handle_air_time(delta)
	var direction := player.get_movement_direction()
	player.velocity.x = direction.x * player.move_speed
	player.position.y = initial_y - height
	
	player.get_sprite_position()
	player.move_and_slide()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == ANIMATIONS[LocalState.TAKEOFF]:
		state = LocalState.JUMP
		height_speed = jump_intensity
	elif anim_name == ANIMATIONS[LocalState.LAND]:
		transition.emit(player.states[player.State.IDLE])

func handle_air_time(delta: float) -> void:
	if state == LocalState.JUMP:
		height += height_speed * delta
		if height < 0:
			height = 0
			state = LocalState.LAND
		else:
			height_speed -= GRAVITY * delta

func exit() -> void:
	player.stop_animation()
	state = null
