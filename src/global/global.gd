extends Node

var cell_size: float = 64.0

#region Audio

var _master_level: float = 1.0
var _music_level: float = 1.0
var _sound_level: float = 1.0

var master_level:
	get:
		return _master_level
	set(value):
		_master_level = clamp(value, 0, 1)
		apply_audio()

var music_level:
	get:
		return _music_level
	set(value):
		_music_level = clamp(value, 0, 1)
		apply_audio()

var sound_level:
	get:
		return _sound_level
	set(value):
		_sound_level = clamp(value, 0, 1)
		apply_audio()

func _linear_to_db_safe(v: float) -> float:
	if v <= 0.0:
		return -80.0 # effectively silent in Godot
	return linear_to_db(v)

func apply_audio():
	var master_idx := AudioServer.get_bus_index("Master")
	var music_idx := AudioServer.get_bus_index("Music")
	var sfx_idx := AudioServer.get_bus_index("SoundEffects")

	AudioServer.set_bus_volume_db(master_idx, _linear_to_db_safe(master_level))
	AudioServer.set_bus_volume_db(music_idx, _linear_to_db_safe(music_level))
	AudioServer.set_bus_volume_db(sfx_idx, _linear_to_db_safe(sound_level))

#endregion
