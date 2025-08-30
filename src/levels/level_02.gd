extends Node2D

func _ready() -> void:
	MapManager.map = $TileMapLayer
	MapManager.player = $Hound
	MapManager.level = 2
	MapManager.dog_head_shift = Vector2i(0, 2)
	
	SignalBus.cell_visited.connect(Callable(self, "route"))
	SignalBus.level_won.connect(Callable(self, "onto_next_level"))

func route(cell: Vector2i):
	if cell in [
		Vector2i(8, 4),
		Vector2i(9, 4),
		Vector2i(9, 5),
	]:
		$UI/ContextHelpShrink.visible = true
	elif cell == Vector2i(7, 5):
		$UI/ContextHelpShrink.visible = false

func onto_next_level():
	Transition.load_scene("res://scenes/levels/level03.tscn")
