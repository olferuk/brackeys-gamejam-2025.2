extends Command
class_name ShrinkCommand

var prev_length: int
var prev_occupied: Array[Vector2i]
var prev_sections: Array[Sprite2D]
var prev_segments: Array[Vector2i]

func execute(hound: Hound) -> bool:
	prev_length = hound.current_length
	prev_occupied = hound.occupied_cells.duplicate(true)
	prev_sections = hound._clone_sections()
	prev_segments = hound.segments.duplicate(true)
	
	return hound._execute_shrink()

func undo(hound: Hound) -> void:
	hound._restore_state(hound.head_coords, hound.prev_direction, prev_occupied, prev_sections, prev_segments)
	hound.current_length = prev_length
