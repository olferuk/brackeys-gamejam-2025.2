extends Node

# all game-wide signals like score_updated or whatever go here
signal restart_level



func _ready() -> void:
	connect("restart_level", Callable(self, "_on_restart_game"))

func _on_restart_game() -> void:
	var current_scene = get_tree().current_scene
	var scene_path = current_scene.scene_file_path
	get_tree().change_scene_to_file(scene_path)
