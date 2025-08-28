extends Node2D

var hide_on_next_move: = false

func _ready() -> void:
	MapManager.map = $GroundTileMapLayer
	MapManager.player = $Hound
	MapManager.level = 1
	MapManager.dog_head_shift = Vector2i(3, 1)

	SignalBus.cell_visited.connect(Callable(self, "show_hint_if_stuck"))

func show_hint_if_stuck(cell: Vector2i):
	if hide_on_next_move:
		$ContextHelp/ContextHelpUndo.visible = false
	if cell == Vector2i(8, 7):
		hide_on_next_move = true
		$ContextHelp/ContextHelpUndo.visible = true
