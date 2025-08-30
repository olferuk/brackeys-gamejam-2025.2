extends Node2D

var hide_on_next_move: = false

func _ready() -> void:
	MapManager.map = $GroundTileMapLayer
	MapManager.player = $Hound
	MapManager.level = 1
	MapManager.dog_head_shift = Vector2i(3, 2)

	SignalBus.cell_visited.connect(Callable(self, "route"))
	SignalBus.starting_to_win.connect(Callable(self, "show_you_win"))
	SignalBus.level_won.connect(Callable(self, "onto_next_level"))

func route(cell: Vector2i) -> void:
	if hide_on_next_move:
		$ContextHelp/ContextHelpUndo.visible = false
	if cell == Vector2i(8, 7):
		hide_on_next_move = true
		$ContextHelp/ContextHelpUndo.visible = true

func show_you_win() -> void:
	$ContextHelp/YouWin.visible = true
	$ContextHelp/YouWin.popup()

func onto_next_level() -> void:
	Transition.load_scene("res://scenes/levels/level02.tscn")
