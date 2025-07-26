extends StaticBody2D

@export var knockback_intensity: float
@export var collectible_type: Collectible.Type

@onready var damage_receiver: DamageReceiver = $DamageReceiver
@onready var sprite: Sprite2D = $Sprite2D

const GRAVITY := 600.0
enum State { IDLE, DAMAGED, DESTROY }

var barrel_bounce_height: float = 0.0
var barrel_bounce_height_speed: float = 0.0
var velocity: Vector2 = Vector2.ZERO
var state: State = State.IDLE
var should_destroy: bool = false

func _ready() -> void:
	damage_receiver.damage_received.connect(on_receive_damage)

func _process(delta: float) -> void:
	if state == State.IDLE:
		return

	position += velocity * delta
	sprite.position.y = -barrel_bounce_height
	handle_air_time(delta)

func on_receive_damage(_damage_amount: int, direction: Vector2, _hit_type: DamageReceiver.HitType) -> void:
	match state:
		State.IDLE:
			sprite.flip_h = direction.x < 0
			sprite.frame = 1
			state = State.DAMAGED
			apply_knockback(direction)
			EntityManager.spawn_collecible.emit(global_position, collectible_type)
		State.DESTROY:
			should_destroy = true
			apply_knockback(direction)

func apply_knockback(direction: Vector2) -> void:
	barrel_bounce_height_speed = knockback_intensity * 3
	velocity = direction * 100

func handle_air_time(delta: float) -> void:
	if state not in [State.DAMAGED, State.DESTROY]:
		return

	barrel_bounce_height += barrel_bounce_height_speed * delta

	if barrel_bounce_height <= 0.0:
		barrel_bounce_height = 0.0
		barrel_bounce_height_speed = 0.0
		velocity = Vector2.ZERO

		if should_destroy:
			queue_free()
		else:
			state = State.DESTROY
	else:
		if should_destroy:
			sprite.modulate.a = max(sprite.modulate.a - delta, 0.0)
		barrel_bounce_height_speed -= GRAVITY * delta
