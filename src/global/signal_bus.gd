extends Node

# all game-wide signals like score_updated or whatever go here
signal restart_level
signal level_won
signal level_lost
signal cell_visited(cell: Vector2i)  


func _ready() -> void:
	restart_level.connect(Callable(self, "_on_restart_game"))
	level_won.connect(Callable(self, "_on_level_won"))
	level_lost.connect(Callable(self, "_on_level_lost"))
	cell_visited.connect(Callable(self, "_on_cell_visited"))

func _on_restart_game() -> void:
	Transition.reload_scene()

func _on_level_won():
	print("Level ", MapManager.level, " won")

func _on_level_lost():
	print("Level ", MapManager.level, " lost")

func _on_cell_visited(cell: Vector2i):
	print("Cell ", cell, " visited")
