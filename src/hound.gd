class_name Hound
extends Node2D

@onready var body_sections: Node2D = $BodySections
@onready var dog_body_layer: TileMapLayer = $DogBodyLayer

@export var maximum_length: int = 7
@export var minimal_length: int = 2

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
var prev_prev_direction: Vector2i = Vector2i.ZERO
var head_coords: Vector2i = Vector2i.ZERO
var head_index: int = 0
var input_blocked: bool = false;

var history: Array[Command] = []

func _ready() -> void:
	occupied_cells = []
	for t in [SectionType.TAIL, SectionType.BODY, SectionType.HEAD]:
		var pos = Vector2(current_length * Global.cell_size, 0)
		_add_section(t, pos, Vector2i.RIGHT)
		var cell_coords = Vector2i(current_length, 0)
		occupied_cells.append(cell_coords)
		if t == SectionType.HEAD:
			head_coords = cell_coords
			head_index = 2
		current_length += 1
	prev_direction = Vector2i.RIGHT
	print(current_length)

func _unhandled_input(event: InputEvent) -> void:
	if is_in_progress:
		return
	
	if event.is_action_pressed("RestartLevel"):
		$Sounds/WhooshSound.play()
		SignalBus.restart_level.emit()
	
	if input_blocked:
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
		var cmd: MoveCommand = MoveCommand.new(dir)
		if cmd.execute(self):
			history.append(cmd)
	
	if event.is_action_pressed("stretch"):
		var cmd: StretchCommand = StretchCommand.new()
		cmd.execute(self)
		history.append(cmd)
	
	if event.is_action_pressed("shrink"):
		var cmd: ShrinkCommand = ShrinkCommand.new()
		cmd.execute(self)
		history.append(cmd)
		$Sounds/ShrinkSound.play()
	
	if event.is_action_pressed("undo"):
		undo_last()

func serialize_state() -> EntityState:
	return EntityState.new(self, [
		"occupied_cells",
		"current_length",
		"head_coords",
		"prev_direction"
	])

func deserialize_state(state: EntityState) -> void:
	state.restore(self)
	_rebuild_sprites()

func _clone_sections() -> Array[Sprite2D]:
	var arr: Array[Sprite2D] = []
	for child in body_sections.get_children():
		if child is Sprite2D:
			var spr := Sprite2D.new()
			spr.texture = child.texture
			spr.position = child.position
			spr.rotation = child.rotation
			spr.scale = child.scale
			spr.flip_h = child.flip_h
			spr.flip_v = child.flip_v
			spr.z_index = child.z_index
			spr.centered = child.centered
			spr.region_enabled = child.region_enabled
			if child.region_enabled:
				spr.region_rect = child.region_rect
			arr.append(spr)
	return arr

func _restore_state(
	pd: Vector2i,
	occ: Array[Vector2i],
	sects: Array[Sprite2D],
):
	# Restore logical state
	occupied_cells = occ.duplicate(true)
	current_length = occupied_cells.size()
	prev_direction = pd
	
	head_coords = occupied_cells[occupied_cells.size() - 1] if occupied_cells.size() > 0 else Vector2i.ZERO

	# Remove old visual sections
	for child in body_sections.get_children():
		body_sections.remove_child(child)
		child.queue_free()

	# Restore cloned sprites
	for spr in sects:
		body_sections.add_child(spr)

func undo_last():
	if history.is_empty():
		return
	$Sounds/UndoSound.play()
	var cmd: Command = history.pop_back()
	cmd.undo(self)
	
	MapManager.visit(head_coords)

func _execute_stretch() -> bool:
	if current_length + 1 > maximum_length:
		return false
	
	if (
		_is_going_opposite(prev_direction) or
		_is_crossing_itself(prev_direction) or
		!MapManager.is_walkable(head_coords + prev_direction)
	):
		$Sounds/ErrorSound.play()
		return false
	
	# Move head forward
	head_coords += prev_direction
	occupied_cells.append(head_coords)
	
	current_length = occupied_cells.size()
	_rebuild_sprites()
	
	MapManager.visit(head_coords)
	
	$Sounds/StretchSound.play()
	return true

func _execute_shrink() -> bool:
	if current_length - 1 < minimal_length:
		return false
	
	while current_length > minimal_length:
		occupied_cells.remove_at(0)
		_rebuild_sprites()
		current_length = occupied_cells.size()
	$Sounds/ShrinkSound.play()
	SignalBus.cell_visited.emit(head_coords)
	return true

func _execute_move(direction: Vector2i) -> bool:
	# invalid move
	if (
		_is_going_opposite(direction) or
		_is_crossing_itself(direction) or
		!MapManager.is_walkable(head_coords + direction)
	):
		$Sounds/ErrorSound.play()
		return false

	head_coords += direction
	occupied_cells.append(head_coords)
	prev_direction = direction
	
	current_length = occupied_cells.size()

	if current_length >= maximum_length:
		occupied_cells.remove_at(0)
	
	_rebuild_sprites()
	
	MapManager.visit(head_coords)
	
	($Sounds/Steps.get_children().pick_random() as AudioStreamPlayer).play()
	return true

func _rebuild_sprites():
	# Remove all existing sprites
	for child in body_sections.get_children():
		body_sections.remove_child(child)
		child.queue_free()

	for i in range(occupied_cells.size()):
		var pos = occupied_cells[i] * Global.cell_size
		var spr: Sprite2D
		
		var prev_dir: Vector2i = _direction_from_to(
			occupied_cells[i - 1], occupied_cells[i]
		) if i > 0 else Vector2i.ZERO
		
		var next_dir: Vector2i = _direction_from_to(
			occupied_cells[i], occupied_cells[i+1]
		) if i < occupied_cells.size()-1 else Vector2i.ZERO
		
		var atlas_coords: Vector2i = Vector2i.ZERO
		
		if i == 0:
			# Tail
			atlas_coords = _get_atlas_coords(SectionType.TAIL, next_dir)
		elif i == occupied_cells.size() - 1:
			# Head
			atlas_coords = _get_atlas_coords(SectionType.HEAD, prev_dir)
		else:
			# Body
			if prev_dir == next_dir:
				atlas_coords = body_schema.body_h if prev_dir.x != 0 else body_schema.body_v
			else:
				atlas_coords = _get_atlas_coords(SectionType.BODY, next_dir, prev_dir)
		# Create and add sprite
		spr = _extract_sprite(dog_body_layer, atlas_coords)
		spr.position = pos
		body_sections.add_child(spr)
	head_index = body_sections.get_child_count() - 1

func _direction_from_to(a: Vector2i, b: Vector2i) -> Vector2i:
	var diff = b - a
	if diff.x > 0:
		return Vector2i.RIGHT
	if diff.x < 0:
		return Vector2i.LEFT
	if diff.y > 0:
		return Vector2i.DOWN
	if diff.y < 0:
		return Vector2i.UP
	return Vector2i.ZERO

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
					(p == Vector2i.LEFT and d  	== Vector2i.UP)):
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

func is_occupied(cell: Vector2i) -> bool:
	return occupied_cells.has(MapManager._dog_cell(cell))

func get_head_position() -> Vector2i:
	return occupied_cells.back()
