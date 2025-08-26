extends Node2D

@export var cell_size := 64
@export var segment_texture: Texture2D
@export var min_length := 3
@export var max_length := 5

@onready var segments := $Segments

var body: Array[Vector2i] = []
var moving := false
var last_dir := Vector2i.RIGHT

@onready var wall_map := $"../TileMapLayer"


func _ready() -> void:
	var start_cell = Vector2i(round(position.x / cell_size), round(position.y / cell_size))
	body.clear()
	for i in range(min_length):
		body.append(start_cell + Vector2i(-i, 0))
	_redraw()


func _unhandled_input(event: InputEvent) -> void:
	if moving:
		return

	var dir := Vector2i.ZERO
	if event.is_action_pressed("move_up"):
		dir = Vector2i(0, -1)
	elif event.is_action_pressed("move_down"):
		dir = Vector2i(0, 1)
	elif event.is_action_pressed("move_left"):
		dir = Vector2i(-1, 0)
	elif event.is_action_pressed("move_right"):
		dir = Vector2i(1, 0)

	if dir != Vector2i.ZERO:
		last_dir = dir
		move_forward(dir)

	# Stretch/shrink
	if event.is_action_pressed("stretch"):
		stretch()
	elif event.is_action_pressed("shrink"):
		shrink()


func move_forward(dir: Vector2i) -> void:
	if moving:
		return
		


	var old_positions: Array[Vector2] = []
	for seg in segments.get_children():
		old_positions.append(seg.position)

	# Compute new body
	var new_head = body[0] + dir
	
	if wall_map.get_cell_source_id(new_head) != -1:
		return # blocked
	moving = true
	
	body.insert(0, new_head)
	body.pop_back()

	if segments.get_child_count() != body.size():
		_redraw()

	# Animate in parallel
	var tw = create_tween()
	for i in range(body.size()):
		var seg = segments.get_child(i)
		tw.parallel() # ⬅️ force simultaneous tweening
		if i == 0:
			tw.tween_property(seg, "position", Vector2(new_head * cell_size), 0.15).set_trans(Tween.TRANS_SINE)
		else:
			tw.tween_property(seg, "position", Vector2(old_positions[i - 1]), 0.15).set_trans(Tween.TRANS_SINE)

	await tw.finished
	moving = false


func _redraw() -> void:
	for c in segments.get_children():
		c.queue_free()
	for cell in body:
		var spr := Sprite2D.new()
		spr.texture = segment_texture
		spr.position = cell * cell_size
		spr.scale = Vector2.ONE
		segments.add_child(spr)


# --- Stretch/Shrink ---
func stretch() -> void:
	if moving or body.size() >= max_length:
		return
	moving = true

	var new_head = body[0] + last_dir
	body.insert(0, new_head)

	var head_sprite = Sprite2D.new()
	head_sprite.texture = segment_texture
	head_sprite.position = body[1] * cell_size
	segments.add_child(head_sprite)
	segments.move_child(head_sprite, 0)

	var tw = create_tween()
	tw.tween_property(head_sprite, "scale", Vector2(1.5, 0.5), 0.07).set_trans(Tween.TRANS_SINE)
	tw.tween_property(head_sprite, "position", Vector2(new_head * cell_size), 0.15).set_trans(Tween.TRANS_SINE)
	tw.tween_property(head_sprite, "scale", Vector2.ONE, 0.07).set_trans(Tween.TRANS_SINE)
	await tw.finished

	_redraw()
	moving = false


func shrink() -> void:
	if moving or body.size() <= min_length:
		return
	moving = true

	#var new_head = body[0] + last_dir
	#body.insert(0, new_head)
	body.pop_back()
	#body.pop_back()
#
	#var head_sprite = Sprite2D.new()
	#head_sprite.texture = segment_texture
	#head_sprite.position = body[1] * cell_size
	#segments.add_child(head_sprite)
	#segments.move_child(head_sprite, 0)
#
	#var tw = create_tween()
	#tw.tween_property(head_sprite, "scale", Vector2(0.5, 1.5), 0.07).set_trans(Tween.TRANS_SINE)
	#tw.tween_property(head_sprite, "position", Vector2(new_head * cell_size), 0.15).set_trans(Tween.TRANS_SINE)
	#tw.tween_property(head_sprite, "scale", Vector2.ONE, 0.07).set_trans(Tween.TRANS_SINE)
	#await tw.finished

	_redraw()
	moving = false
