class_name HealthBar
extends Control

@onready var white_border: ColorRect = $WhiteBorder
@onready var content_background: ColorRect = $ContentBackground
@onready var health_gauge: TextureRect = $HealthGauge

@export var is_inverted: bool = false

func refresh(current_health: int, max_health: int) -> void:
	var rev = -1 if is_inverted else 1
	white_border.scale.x = (max_health + 1) * rev
	content_background.scale.x = max_health * rev
	health_gauge.scale.x = current_health * rev
