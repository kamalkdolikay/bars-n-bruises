class_name Collectible
extends Area2D

@export var speed: float
@export var knockdown_intensity: float

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collectible_sprite: Sprite2D = $CollectibleSprite

const GRAVITY := 600.0
enum State { FALL, GROUNDED, FLY }

var collectible_state := {
	State.FALL: "fall",
	State.GROUNDED: "grounded",
	State.FLY: "fly"
}
var height := 0.0
var height_speed := 0.0
var state = State.FALL

func _ready() -> void:
	height_speed = knockdown_intensity

func _process(delta: float) -> void:
	handle_fall(delta)
	handle_animations()
	collectible_sprite.position = Vector2.UP * height

func handle_animations() -> void:
	animation_player.play(collectible_state[state])

func handle_fall(delta: float) -> void:
	if state == State.FALL:
		height += height_speed * delta
		if height < 0:
			height = 0
			state = State.GROUNDED
		else:
			height_speed -= GRAVITY * delta
