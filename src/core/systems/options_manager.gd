extends Node

var is_screen_shake_enabled: bool = true
var music_volume: int = 5
var sfx_volume: int = 5

func set_music_volume(value: int) -> void:
	music_volume = value
	AudioServer.set_bus_volume_db(1, linear_to_db(value / 10.0))
	
func set_sfx_volume(value: int) -> void:
	sfx_volume = value
	AudioServer.set_bus_volume_db(2, linear_to_db(value / 10.0))

func set_screen_shake(value: bool) -> void:
	is_screen_shake_enabled = value
