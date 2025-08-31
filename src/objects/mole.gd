extends Entity
class_name Mole


@export_group("Behaviour")
@export var path: Array[Vector2i] = []
@export var direction: Vector2i = Vector2i.RIGHT
@export_enum(&"Ping Pong", &"Cycled") var move_type: String = &"Ping Pong"
var _path_i: int = 0


func _ready() -> void:
	super._ready()

func player_moved() -> void:
	# move by path
	if direction == Vector2i.RIGHT:
		_path_i += 1
	else:
		_path_i -= 1
	
	if move_type == &"Ping Pong":
		if _path_i == len(path)-1:
			direction *= -1
			$Icon.flip_h = true
		elif _path_i == 0:
			direction *= -1
			$Icon.flip_h = false
	else:
		if _path_i == len(path) and direction == Vector2i.RIGHT:
			_path_i = 0
		if _path_i == -1 and direction == Vector2i.LEFT:
			_path_i = len(path)-1
	
	if _path_i > len(path) or _path_i < 0:
		return

	cell = path[_path_i]
	position = Global.cell_size * path[_path_i] + Vector2(0, 16)
	
	if MapManager.is_occupied_by_dog(cell):
		SignalBus.emit_signal("level_lost")
