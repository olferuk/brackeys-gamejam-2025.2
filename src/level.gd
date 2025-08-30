extends Node2D

var hide_on_next_move: = false

func _ready() -> void:
	MapManager.map = $GroundTileMapLayer
	MapManager.player = $Hound
	MapManager.level = 1
	MapManager.dog_head_shift = Vector2i(3, 2)

	SignalBus.cell_visited.connect(Callable(self, "route"))

func route(cell: Vector2i):
	if hide_on_next_move:
		$ContextHelp/ContextHelpUndo.visible = false
	if cell == Vector2i(8, 7):
		hide_on_next_move = true
		$ContextHelp/ContextHelpUndo.visible = true
