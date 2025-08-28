extends Node

# all game-wide signals like score_updated or whatever go here
signal restart_level
signal cell_visited(cell: Vector2i)


func _ready() -> void:
	restart_level.connect(Callable(self, "_on_restart_game"))

func _on_restart_game() -> void:
	Transition.reload_scene()
