extends Node2D

@onready var label_2: Label = $Label2
@onready var label_3: Label = $Label3
@onready var timer: Timer = $Timer


func _ready():
	label_2.visible = true
	label_3.visible = false
	timer.timeout.connect(_on_timer_timeout)

func _on_timer_timeout():
	label_2.visible = !label_2.visible
	label_3.visible = !label_3.visible
