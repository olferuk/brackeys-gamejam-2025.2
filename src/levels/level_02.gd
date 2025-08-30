extends Node2D

func _ready() -> void:
	MapManager.map = $GroundTileMapLayer
	MapManager.player = $Hound
	MapManager.level = 2
	MapManager.dog_head_shift = Vector2i(3, 2)

	SignalBus.cell_visited.connect(Callable(self, "route"))

func route(cell: Vector2i):
	pass
