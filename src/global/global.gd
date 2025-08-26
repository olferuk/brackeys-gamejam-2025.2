extends Node

# var main: Main Scene
var rng: RandomNumberGenerator
# var managers: ....
var gameSpeed: float = 1.0

var cellSize: float = 64

# Sound levels
var masterLevel: float = 1.0
var musicLevel: float = 1.0
var soundLevel: float = 1.0

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
