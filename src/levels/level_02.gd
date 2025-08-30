extends Node2D

func _ready() -> void:
	MapManager.map = $TileMapLayer
	MapManager.player = $Hound
	MapManager.level = 2
	MapManager.dog_head_shift = Vector2i(0, 2)
	
	#SignalBus.cell_visited.connect(Callable(self, "route"))
	SignalBus.starting_to_win.connect(Callable(self, "show_you_win"))
	SignalBus.level_won.connect(Callable(self, "onto_next_level"))

#func route(_cell: Vector2i):
	#pass

func show_you_win():
	$UI/YouWin.visible = true
	$UI/YouWin.popup()

func onto_next_level():
	print("Loading level 3")
