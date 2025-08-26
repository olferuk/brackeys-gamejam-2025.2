class_name Hound
extends Node2D

@onready var body_sections: Node2D = $BodySections
@onready var dog_body_layer: TileMapLayer = $DogBodyLayer

@export var maximum_length: int = 7

@export var body_schema: BodySchema

enum SectionType {
	HEAD,
	TAIL,
	BODY
}

var is_in_progress: bool = false
var current_length: int = 0
var occupied_cells: Array[Vector2i] = []
var prev_direction: Vector2i = Vector2i.ZERO

var head_coords: Vector2i = Vector2i.ZERO
var head_index: int = 0


func _ready() -> void:
	for t in [SectionType.TAIL, SectionType.BODY, SectionType.HEAD]:
		_add_section(t, Vector2(current_length*Global.cell_size, 0), Vector2i.RIGHT)
		occupied_cells.append(Vector2i(current_length, 0))
		if t == SectionType.HEAD:
			head_coords = Vector2i(current_length, 0)
			head_index = 2
		current_length += 1
	prev_direction = Vector2i.RIGHT

func _unhandled_input(event: InputEvent) -> void:
	if is_in_progress:
		return
	
	var dir := Vector2i.ZERO
	if event.is_action_pressed("move_up"): 
		dir = Vector2i.UP
		print("^")
	elif event.is_action_pressed("move_down"):
		dir = Vector2i.DOWN
		print("v")
	elif event.is_action_pressed("move_left"):
		dir = Vector2i.LEFT
		print("<")
	elif event.is_action_pressed("move_right"):
		dir = Vector2i.RIGHT
		print(">")

	if dir != Vector2i.ZERO:
		try_move_forward(dir)

	if event.is_action_pressed("stretch"):
		$Sounds/StretchSound.play()

	if event.is_action_pressed("shrink"):
		$Sounds/ShrinkSound.play()
	
	if event.is_action_pressed("RestartLevel"):
		SignalBus.restart_level.emit()

func try_move_forward(direction: Vector2i):
	# TODO: and also check for walls in the direction of movement
	if _is_going_opposite(direction) or _is_crossing_itself(direction):
		$Sounds/ErrorSound.play()
		return
	
	#is_in_progress = true
	# spawn new part
	if direction == prev_direction:
		_add_section(SectionType.BODY, head_coords*Global.cell_size, direction)
	else:
		_add_section(SectionType.BODY, head_coords*Global.cell_size, direction)
	
	#move head
	var head := body_sections.get_child(head_index) as Sprite2D
	head.position += direction*Global.cell_size
	head_coords += direction
	
	# change state
	occupied_cells.append(head_coords)
	prev_direction = direction

func _is_going_opposite(direction: Vector2i) -> bool:
	return (-1)*direction == prev_direction

func _is_crossing_itself(direction: Vector2i) -> bool:
	return (head_coords + direction) in occupied_cells

func _add_section(section_type: SectionType, spawn_at: Vector2, orient_towards: Vector2i):
	var cell: Vector2i = _get_atlas_coords(section_type, orient_towards)
	
	# TODO: do not cut on the fly, pre-cut, put in a hidden group, copy whenever needed
	var spr: Sprite2D = _extract_sprite(dog_body_layer, cell)
	spr.position = spawn_at
	body_sections.add_child(spr)

func _get_atlas_coords(section_type: SectionType, orient_towards: Vector2i) -> Vector2i:
	match section_type:
		SectionType.TAIL:
			match orient_towards:
				Vector2i.LEFT:
					return body_schema.tail_left
				Vector2i.RIGHT:
					return body_schema.tail_right
				Vector2i.UP:
					return body_schema.tail_up
				Vector2i.DOWN:
					return body_schema.tail_down
		SectionType.HEAD:
			match orient_towards:
				Vector2i.LEFT:
					return body_schema.head_left
				Vector2i.RIGHT:
					return body_schema.head_right
				Vector2i.UP:
					return body_schema.head_up
				Vector2i.DOWN:
					return body_schema.head_down
		SectionType.BODY:
			match orient_towards:
				Vector2i.LEFT:
					return body_schema.body_h
				Vector2i.RIGHT:
					return body_schema.body_h
				Vector2i.UP:
					return body_schema.body_v
				Vector2i.DOWN:
					return body_schema.body_v
	return Vector2i.ZERO

func _extract_sprite(ts: TileMapLayer, atlas_coords: Vector2i) -> Sprite2D:
	var src = ts.tile_set.get_source(0) as TileSetAtlasSource
	var region: Rect2i = src.get_tile_texture_region(atlas_coords)
	var tex := AtlasTexture.new(); tex.atlas = src.get_texture(); tex.region = region
	var spr := Sprite2D.new(); spr.texture = tex; spr.centered = false
	return spr
