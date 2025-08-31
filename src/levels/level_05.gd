extends Node2D

func _ready() -> void:
	MapManager.map = $TileMapLayer
	MapManager.player = $Hound
	MapManager.level = 5
	MapManager.dog_head_shift = Vector2i(0, 2)
	
	SignalBus.cell_visited.connect(Callable(self, "route"))
	SignalBus.level_won.connect(Callable(self, "onto_next_level"))
	SignalBus.level_lost.connect(Callable(self, "player_lose"))
	SignalBus.restart_level.connect(Callable(self, "restarted"))

func route(cell: Vector2i) -> void:
	if cell == Vector2i(10, 6) and $Camera2D.position == Vector2(0, 0):
		move_camera(1000, 0)
	elif cell == Vector2i(20, 4) and $Camera2D.position == Vector2(1000, 0):
		move_camera(1500, 0)
	elif cell == Vector2i(21, 7) and $Camera2D.position == Vector2(1500, 0):
		move_camera(1380, 470)

func move_camera(x: float, y: float):
	var t = create_tween()
	t.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	t.tween_property($Camera2D, ^"position", Vector2(x, y), 0.4)

func onto_next_level():
	Transition.load_scene(Consts.get_scene_name(Consts.SceneName.CREDITS))

func player_lose():
	$PostFx.play_postfx()
	$Hound.input_blocked = true

func restarted():
	$PostFx.stop_postfx()
	$Hound.input_blocked = false
