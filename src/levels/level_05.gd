extends Node2D

func _ready() -> void:
	MapManager.map = $TileMapLayer
	MapManager.player = $Hound
	MapManager.level = 5
	MapManager.dog_head_shift = Vector2i(0, 2)
	
	SignalBus.cell_visited.connect(Callable(self, "route"))
	SignalBus.level_won.connect(Callable(self, "onto_next_level"))
	SignalBus.level_lost.connect(Callable(self, "player_lose"))

func route(cell: Vector2i) -> void:
	if cell == Vector2i(10, 6) and $Camera2D.position == Vector2(0, 0):
		var t = create_tween()
		t.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
		t.tween_property($Camera2D, ^"position", Vector2(1000, 0), 0.4)

func onto_next_level():
	#Transition.load_scene("res://scenes/levels/level05.tscn")
	pass

func player_lose():
	pass
