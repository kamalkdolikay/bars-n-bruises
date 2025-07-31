class_name OptionsScreen
extends Control

@onready var music_control: ActivableControl = $Background/MarginContainer/VBoxContainer/MusicVolumeControl
@onready var sound_control: ActivableControl = $Background/MarginContainer/VBoxContainer/SoundVolumeControl
@onready var shake_toggle: ActivableControl = $Background/MarginContainer/VBoxContainer/ShakeToggle
@onready var return_button: ActivableControl = $Background/MarginContainer/VBoxContainer/ReturnButton
@onready var activables: Array[ActivableControl] = [music_control, sound_control, shake_toggle, return_button]

var current_selection_index: int = 0

func _ready() -> void:
	refresh()

func _process(_delta: float) -> void:
	handle_input()

func refresh() -> void:
	
	for i in range(0, activables.size()):
		activables[i].set_active(current_selection_index == i)

func handle_input() -> void:
	if Input.is_action_just_pressed("ui_down"):
		current_selection_index = clampi(current_selection_index + 1, 0, activables.size() - 1)
		refresh()
	if Input.is_action_just_pressed("ui_up"):
		current_selection_index = clampi(current_selection_index - 1, 0, activables.size() - 1)
		refresh()
