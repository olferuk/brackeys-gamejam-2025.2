extends Node

# var main: Main Scene
var rng: RandomNumberGenerator
var gameSpeed: float = 1.0


#region Audio

var _masterLevel: float = 1.0
var _musicLevel: float = 1.0
var _soundLevel: float = 1.0

var masterLevel:
	get:
		return _masterLevel
	set(value):
		_masterLevel = clamp(value, 0, 1)
		apply_audio()

var musicLevel:
	get:
		return _musicLevel
	set(value):
		_musicLevel = clamp(value, 0, 1)
		apply_audio()

var soundLevel:
	get:
		return _soundLevel
	set(value):
		_soundLevel = clamp(value, 0, 1)
		apply_audio()

func _linear_to_db_safe(v: float) -> float:
	if v <= 0.0:
		return -80.0 # effectively silent in Godot
	return linear_to_db(v)

func apply_audio():
	var master_idx := AudioServer.get_bus_index("Master")
	var music_idx := AudioServer.get_bus_index("Music")
	var sfx_idx := AudioServer.get_bus_index("SoundEffects")

	AudioServer.set_bus_volume_db(master_idx, _linear_to_db_safe(masterLevel))
	AudioServer.set_bus_volume_db(music_idx,  _linear_to_db_safe(musicLevel))
	AudioServer.set_bus_volume_db(sfx_idx,    _linear_to_db_safe(soundLevel))

#endregion
