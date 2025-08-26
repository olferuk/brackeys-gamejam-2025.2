extends Node2D

@export var min_height := 3
@export var max_height := 5
@export var cell_size := 64
@export var segment_texture: Texture2D

@onready var segments := $Segments

var current_height := 3
var player_cell := Vector2i.ZERO
var stretching := false

func _ready() -> void:
	_rebuild_segments()
	# Snap to grid
	player_cell = Vector2i(round(position.x / cell_size), round(position.y / cell_size))
	position = player_cell * cell_size

func _unhandled_input(event: InputEvent) -> void:
	#if stretching:
		#return
	
	#if event.is_action_pressed("stretch") and current_height < max_height:
		#stretch_to(current_height + 1)
	#elif event.is_action_pressed("shrink") and current_height > min_height:
		#stretch_to(current_height - 1)
	
	if event.is_action_pressed("move_up"):
		print("hello")
		try_move(Vector2i.UP)
	elif event.is_action_pressed("move_down"):
		try_move(Vector2i.DOWN)
	elif event.is_action_pressed("move_left"):
		try_move(Vector2i.LEFT)
	elif event.is_action_pressed("move_right"):
		try_move(Vector2i.RIGHT)

func _rebuild_segments() -> void:
	for c in segments.get_children():
		c.queue_free()
	for i in range(current_height):
		var spr := Sprite2D.new()
		spr.texture = segment_texture
		spr.position = Vector2(0, -i * cell_size)
		segments.add_child(spr)

func stretch_to(new_height: int) -> void:
	stretching = true
	if new_height > current_height:
		# Add segments one by one
		for i in range(current_height, new_height):
			var spr := Sprite2D.new()
			spr.texture = segment_texture
			spr.position = Vector2(0, -(i+1) * cell_size) + Vector2(0, cell_size)
			spr.scale = Vector2(1, 0.1)
			segments.add_child(spr)
			var tw := create_tween()
			tw.tween_property(spr, "position", Vector2(0, -i * cell_size), 0.2)
			tw.parallel().tween_property(spr, "scale", Vector2(1, 1), 0.2)
			await tw.finished
	else:
		# Remove top segments
		for i in range(current_height-1, new_height-1, -1):
			var spr := segments.get_child(i)
			var tw := create_tween()
			tw.tween_property(spr, "scale", Vector2(1, 0.1), 0.2)
			tw.parallel().tween_property(spr, "modulate:a", 0.0, 0.2)
			await tw.finished
			spr.queue_free()

	current_height = new_height
	stretching = false

func try_move(dir: Vector2i) -> void:
	var target_cell = player_cell + dir
	# For now no walls → just move
	player_cell = target_cell
	var dest = player_cell * cell_size
	#var tw = create_tween()
	#tw.tween_property(self, "position", dest, 0.15)
