extends Command
class_name StretchCommand

var prev_length: int
var prev_occupied: Array[Vector2i]
var prev_sections: Array[Sprite2D]

func execute(hound: Hound) -> bool:
	prev_length = hound.current_length
	prev_occupied = hound.occupied_cells.duplicate(true)
	prev_sections = hound._clone_sections()
	return hound._execute_stretch()

func undo(hound: Hound) -> void:
	hound._restore_state(hound.head_coords, hound.prev_direction, prev_occupied, prev_sections)
	hound.current_length = prev_length
