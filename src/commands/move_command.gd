extends Command
class_name MoveCommand

var direction: Vector2i
var prev_head_coords: Vector2i
var prev_direction: Vector2i
var prev_occupied: Array[Vector2i]
var prev_sections: Array[Sprite2D]
var prev_segments: Array[Vector2i]

func _init(dir: Vector2i) -> void:
	direction = dir

func execute(hound: Hound) -> bool:
	prev_head_coords = hound.head_coords
	prev_direction = hound.prev_direction
	prev_occupied = hound.occupied_cells.duplicate(true)
	prev_sections = hound._clone_sections()
	prev_segments = hound.segments.duplicate(true) 
	return hound._execute_move(direction)

func undo(hound: Hound) -> void:
	hound._restore_state(hound.head_coords, hound.prev_direction, prev_occupied, prev_sections, prev_segments)
