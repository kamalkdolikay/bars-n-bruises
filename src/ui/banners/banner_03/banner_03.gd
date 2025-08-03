extends Node2D

@onready var label2 = $Label2
@onready var label3 = $Label3
var float_amount := 4
var float_duration := 0.5

func _ready():
	get_viewport().transparent_bg = true
	start_float_animation1()
	start_float_animation2()

func start_float_animation1():
	var tween = create_tween()
	tween.set_loops()  # infinite loop

	tween.tween_property(label2, "position:y", label2.position.y - float_amount, float_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(label2, "position:y", label2.position.y + float_amount, float_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
func start_float_animation2():
	var tween = create_tween()
	tween.set_loops()

	tween.tween_property(label3, "position:y", label3.position.y + float_amount, float_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(label3, "position:y", label3.position.y - float_amount, float_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)	
