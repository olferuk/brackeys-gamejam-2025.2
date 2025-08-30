extends Node

# all game-wide signals like score_updated or whatever go here
signal restart_level
signal starting_to_win
signal level_won
signal level_lost
signal cell_visited(cell: Vector2i)  


func _ready() -> void:
	restart_level.connect(Callable(self, "_on_restart_game"))
	level_won.connect(Callable(self, "_on_level_won"))
	level_lost.connect(Callable(self, "_on_level_lost"))
	cell_visited.connect(Callable(self, "_on_cell_visited"))
	starting_to_win.connect(Callable(self, "_on_starting_to_win"))

func _on_restart_game() -> void:
	Transition.reload_scene()

func _on_level_won() -> void:
	print("Level ", MapManager.level, " won")

func _on_level_lost() -> void:
	print("Level ", MapManager.level, " lost")

func _on_cell_visited(cell: Vector2i) -> void:
	print("Cell ", cell, " visited")

func _on_starting_to_win() -> void:
	print("Starting to win")
