class_name JumpState
extends CharacterState

const GRAVITY := 600.0

@export var player: PlayerCharacter
@export var jump_intensity: float

var height := 0.0
var height_speed := 0.0
var state = null
var initial_y: float = 0.0

enum State { TAKEOFF, JUMP, LAND }

var jump_state := {
	State.TAKEOFF: "takeoff",
	State.JUMP: "jump",
	State.LAND: "land"
}

func enter() -> void:
	if not player.animation_player.is_connected("animation_finished", Callable(self, "_on_animation_finished")):
		player.animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))

	player.animation_player.play(jump_state[State.TAKEOFF])
	initial_y = player.position.y

func update(delta: float) -> void:
	if state != null:
		player.animation_player.play(jump_state[state])
		
	handle_air_time(delta)
	var direction = player.get_movement_direction()
	player.velocity.x = direction.x * player.move_speed
	player.position.y = initial_y - height
	
	player.get_sprite_position(direction)
	player.move_and_slide()

func _on_animation_finished(animation_state: String) -> void:
	if animation_state == jump_state[State.TAKEOFF]:
		state = State.JUMP
		height_speed = jump_intensity
	elif animation_state == jump_state[State.LAND]:
		transition.emit("Idle")

func handle_air_time(delta: float) -> void:
	if state == State.JUMP:
		height += height_speed * delta
		if height < 0:
			height = 0
			state = State.LAND
		else:
			height_speed -= GRAVITY * delta

func exit() -> void:
	if player.animation_player.is_connected("animation_finished", Callable(self, "_on_animation_finished")):
		player.animation_player.disconnect("animation_finished", Callable(self, "_on_animation_finished"))
		
	player.animation_player.stop()
	state = null
