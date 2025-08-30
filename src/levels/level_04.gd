extends Node2D

func _ready() -> void:
	MapManager.map = $TileMapLayer
	MapManager.player = $Hound
	MapManager.level = 4
	MapManager.dog_head_shift = Vector2i(0, 2)
	
	SignalBus.cell_visited.connect(Callable(self, "route"))
	SignalBus.level_won.connect(Callable(self, "onto_next_level"))
	SignalBus.level_lost.connect(Callable(self, "player_lose"))
	
	configure_hide_label()

func route(cell):
	if cell in [Vector2i(6,7), Vector2i(7,7)]:
		$UI/ContextHelpRestart.visible = true
	elif cell.y == 8:
		$UI/ContextHelpRestart.visible = false

func onto_next_level():
	Transition.load_scene("res://scenes/levels/level05.tscn")

func player_lose():
	print("You HAVE FAILEEDDD")

func configure_hide_label():
	var t = create_tween()
	(
		t.set_ease(Tween.EASE_IN)
		 .set_trans(Tween.TRANS_CUBIC)
		 .tween_property($UI/Hide, ^"position:x", 280, 0.5)
	)
	(
		t.set_ease(Tween.EASE_OUT)
		 .set_trans(Tween.TRANS_CUBIC)
		 .tween_property($UI/Hide, ^"position:x", 256, 0.5)
	)
	t.set_loops(-1)
