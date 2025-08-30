extends Node2D

func _ready() -> void:
	MapManager.map = $TileMapLayer
	MapManager.player = $Hound
	MapManager.level = 2
	MapManager.dog_head_shift = Vector2i(0, 2)
	
	SignalBus.level_won.connect(Callable(self, "onto_next_level"))

func onto_next_level():
	Transition.load_scene("res://scenes/levels/level03.tscn")
