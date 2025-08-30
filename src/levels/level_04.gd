extends Node2D

func _ready() -> void:
	MapManager.map = $TileMapLayer
	MapManager.player = $Hound
	MapManager.level = 4
	MapManager.dog_head_shift = Vector2i(0, 2)
	
	SignalBus.level_won.connect(Callable(self, "onto_next_level"))
	SignalBus.level_lost.connect(Callable(self, "player_lose"))

func onto_next_level():
	#Transition.load_scene("res://scenes/levels/level05.tscn")
	pass

func player_lose():
	print("You HAVE FAILEEDDD")
