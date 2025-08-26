extends Node2D

@export var cell_size := 64
@export var segment_texture: Texture2D

@onready var segments := $Segments

var player_cell := Vector2i.ZERO
var moving := false

func _ready() -> void:
	# Start on nearest grid cell
	player_cell = Vector2i(round(position.x / cell_size), round(position.y / cell_size))
	position = player_cell * cell_size
	_build_segments()

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
	print(dir)
	if dir != Vector2i.ZERO:
		move_to(player_cell + dir)

func move_to(target: Vector2i) -> void:
	# Wall check
	#if wall_map.get_cell_source_id(target) != -1:
		#return

	# If already there, skip
	if target == player_cell:
		return

	moving = true
	print(player_cell, target)
	
	player_cell = target

	var target_pos = player_cell * cell_size
	var tw = create_tween()
	tw.tween_property(self, "position", Vector2(target_pos), 0.15)
	await tw.finished
	moving = false




func _build_segments() -> void:
	# Clear old
	for c in segments.get_children():
		c.queue_free()
	# Add 3 stacked sprites
	for i in range(3):
		var spr := Sprite2D.new()
		spr.texture = segment_texture
		spr.position = Vector2(0, -i * cell_size)
		segments.add_child(spr)
