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

var history: Array[Command] = []

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
	elif event.is_action_pressed("move_down"):
		dir = Vector2i.DOWN
	elif event.is_action_pressed("move_left"):
		dir = Vector2i.LEFT
	elif event.is_action_pressed("move_right"):
		dir = Vector2i.RIGHT

	if dir != Vector2i.ZERO:
		var cmd := MoveCommand.new(dir)
		if cmd.execute(self):
			history.append(cmd)

	if event.is_action_pressed("stretch"):
		var cmd := StretchCommand.new()
		cmd.execute(self)
		history.append(cmd)

	if event.is_action_pressed("shrink"):
		var cmd := ShrinkCommand.new()
		cmd.execute(self)
		history.append(cmd)
	#$Sounds/ShrinkSound.play()
	if event.is_action_pressed("Undo"):
		undo_last()

	if event.is_action_pressed("RestartLevel"):
		SignalBus.restart_level.emit()

func _clone_sections() -> Array[Sprite2D]:
	var arr: Array[Sprite2D] = []
	for child in body_sections.get_children():
		if child is Sprite2D:
			var spr := Sprite2D.new()
			spr.texture = child.texture
			spr.position = child.position
			spr.centered = false
			arr.append(spr)
	return arr

func _restore_state(hc: Vector2i, pd: Vector2i, occ: Array[Vector2i], sections: Array[Sprite2D]):
	head_coords = hc
	prev_direction = pd
	occupied_cells = occ.duplicate(true)

	for c in body_sections.get_children():
		body_sections.remove_child(c)
		c.queue_free() 
	for spr in sections:
		body_sections.add_child(spr)

func undo_last():
	if history.is_empty():
		return
	var cmd: Command = history.pop_back()
	cmd.undo(self)

func _execute_stretch():
	current_length += 1
	$Sounds/StretchSound.play()

func _execute_shrink():
	if current_length > 1:
		current_length -= 1
		$Sounds/ShrinkSound.play()
		

func _execute_move(direction: Vector2i) -> bool:
	if _is_going_opposite(direction) or _is_crossing_itself(direction):
		$Sounds/ErrorSound.play()
		return false

	# spawn straight/curve section
	if direction == prev_direction:
		_add_section(SectionType.BODY, head_coords * Global.cell_size, direction)
	else:
		_add_section(SectionType.BODY, head_coords * Global.cell_size, direction, prev_direction)

	# move head
	head_coords += direction
	var head := body_sections.get_child(head_index) as Sprite2D
	head.position += direction * Global.cell_size
	if direction != prev_direction:
		head.texture = _extract_texture(
			dog_body_layer,
			_get_atlas_coords(SectionType.HEAD, direction, prev_direction)
		)

	# sound + state
	$Sounds/StretchSound.play()
	occupied_cells.append(head_coords)
	prev_direction = direction
	return true

func _is_going_opposite(direction: Vector2i) -> bool:
	return (-1)*direction == prev_direction

func _is_crossing_itself(direction: Vector2i) -> bool:
	return (head_coords + direction) in occupied_cells

func _add_section(
	section_type: SectionType,
	spawn_at: Vector2,
	new_direction: Vector2i,
	old_direction: Vector2i = Vector2i.ZERO
) -> void:
	var cell: Vector2i = _get_atlas_coords(
		section_type, new_direction, old_direction
	)
	
	# TODO: do not cut on the fly, pre-cut, put in a hidden group, copy whenever needed
	var spr: Sprite2D = _extract_sprite(dog_body_layer, cell)
	spr.position = spawn_at
	body_sections.add_child(spr)

func _get_atlas_coords(
	section_type: SectionType,
	new_direction: Vector2i,
	old_direction: Vector2i = Vector2i.ZERO
) -> Vector2i:
	match section_type:
		SectionType.TAIL:
			match new_direction:
				Vector2i.LEFT:
					return body_schema.tail_left
				Vector2i.RIGHT:
					return body_schema.tail_right
				Vector2i.UP:
					return body_schema.tail_up
				Vector2i.DOWN:
					return body_schema.tail_down
		SectionType.HEAD:
			match new_direction:
				Vector2i.LEFT:
					return body_schema.head_left
				Vector2i.RIGHT:
					return body_schema.head_right
				Vector2i.UP:
					return body_schema.head_up
				Vector2i.DOWN:
					return body_schema.head_down
		SectionType.BODY:
			if old_direction == Vector2i.ZERO:
				match new_direction:
					Vector2i.LEFT:
						return body_schema.body_h
					Vector2i.RIGHT:
						return body_schema.body_h
					Vector2i.UP:
						return body_schema.body_v
					Vector2i.DOWN:
						return body_schema.body_v
			else:
				var d = new_direction
				var p = old_direction
				if (p == Vector2i.LEFT and d == Vector2i.DOWN or
					p == Vector2i.UP and d == Vector2i.RIGHT):
						return body_schema.body_c1100
				if (p == Vector2i.RIGHT and d == Vector2i.DOWN or
					p == Vector2i.UP and d == Vector2i.LEFT):
						return body_schema.body_c0110
				if (p == Vector2i.RIGHT and d == Vector2i.UP or
					p == Vector2i.DOWN and d == Vector2i.LEFT):
						return body_schema.body_c0011
				if ((p == Vector2i.DOWN and d == Vector2i.RIGHT) or
					(p == Vector2i.LEFT and d == Vector2i.UP)):
						return body_schema.body_c1001
	return Vector2i.ZERO

func _extract_texture(ts: TileMapLayer, atlas_coords: Vector2i) -> Texture2D:
	var src = ts.tile_set.get_source(0) as TileSetAtlasSource
	var region: Rect2i = src.get_tile_texture_region(atlas_coords)
	var tex := AtlasTexture.new();
	tex.atlas = src.get_texture();
	tex.region = region
	return tex

func _extract_sprite(ts: TileMapLayer, atlas_coords: Vector2i) -> Sprite2D:
	var spr := Sprite2D.new();
	spr.texture = _extract_texture(ts, atlas_coords);
	spr.centered = false
	return spr
