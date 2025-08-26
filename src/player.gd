extends Node2D

@export var min_length := 3
@export var max_length := 5
@export var move_speed := 5.0      # higher = faster interpolation
@export var squash_amount := 0.2   # cartoony squash/stretch factor

@onready var body := $Body
@onready var head_sprite := $HeadSprite

var body_cells: Array[Vector2i] = []           # logical grid positions
var body_cells_visual: Array[Vector2] = []     # pixel positions for smooth animation
var moving := false
var last_dir := Vector2i.RIGHT
var stretch_factor := 0.0                      # squash/stretch applied per frame

func _ready() -> void:
	# Initialize body horizontally, each segment at a different X
	var start = Vector2i(0, 0)
	for i in range(min_length):
		body_cells.append(start + Vector2i(-i, 0))  # horizontal: X decreases
		body_cells_visual.append(Vector2((start.x - i) * Global.cellSize, start.y * Global.cellSize))
	_update_polygon(body_cells_visual, 0.0)
	print(body_cells_visual)

func _process(delta: float) -> void:
	# Smoothly interpolate body segments to grid positions
	for i in range(body_cells.size()):
		var target = Vector2(body_cells[i].x * Global.cellSize, body_cells[i].y * Global.cellSize)
		body_cells_visual[i] = body_cells_visual[i].lerp(target, move_speed * delta)

	# Apply squash/stretch
	_update_polygon(body_cells_visual, stretch_factor)

	# Move head sprite
	head_sprite.position = body_cells_visual[0]
	head_sprite.scale = Vector2(1 + stretch_factor, 1 - stretch_factor)

func _unhandled_input(event: InputEvent) -> void:
	if moving:
		return

	var dir := Vector2i.ZERO
	if event.is_action_pressed("move_up"): dir = Vector2i(0, -1)
	elif event.is_action_pressed("move_down"): dir = Vector2i(0, 1)
	elif event.is_action_pressed("move_left"): dir = Vector2i(-1, 0)
	elif event.is_action_pressed("move_right"): dir = Vector2i(1, 0)

	if dir != Vector2i.ZERO:
		last_dir = dir
		move_forward(dir)

	if event.is_action_pressed("stretch"): stretch()
	elif event.is_action_pressed("shrink"): shrink()

# --- movement ---
func move_forward(dir: Vector2i) -> void:
	if moving:
		return
	moving = true

	var new_head = body_cells[0] + dir

	# TODO: add wall collision here if needed

	body_cells.insert(0, new_head)
	body_cells.pop_back()

	_start_squash_animation(squash_amount)
	moving = false

# --- stretch/shrink ---
func stretch() -> void:
	if moving or body_cells.size() >= max_length: return
	moving = true

	var new_head = body_cells[0] + last_dir
	body_cells.insert(0, new_head)

	# Insert a new visual segment at the same position as the old head (so it grows smoothly)
	body_cells_visual.insert(0, body_cells_visual[0])

	_start_squash_animation(squash_amount)
	moving = false

func shrink() -> void:
	if moving or body_cells.size() <= min_length: return
	moving = true

	var new_head = body_cells[0] + last_dir
	body_cells.insert(0, new_head)
	body_cells.pop_back()
	body_cells.pop_back()

	# Keep visual array in sync
	body_cells_visual.insert(0, body_cells_visual[0])
	body_cells_visual.pop_back()
	body_cells_visual.pop_back()

	_start_squash_animation(-squash_amount)
	moving = false

# --- polygon update ---
func _update_polygon(positions: Array[Vector2], stretch_value: float) -> void:
	var poly: Array[Vector2] = []
	var half_width = Global.cellSize / 2.0

	if positions.size() < 2:
		return

	# Compute perpendicular offsets for each segment
	var top_points: Array[Vector2] = []
	var bottom_points: Array[Vector2] = []

	for i in range(positions.size()):
		var p = positions[i]
		var dir: Vector2
		if i == 0:
			dir = positions[1] - positions[0]
		elif i == positions.size() - 1:
			dir = positions[i] - positions[i - 1]
		else:
			dir = positions[i + 1] - positions[i - 1]

		var normal = dir.normalized().orthogonal()  # perpendicular to spine
		var t = float(i) / float(positions.size() - 1)
		var scale_value = lerp(1.0 + stretch_value * 0.5, 1.0, t)
		top_points.append(p + normal * half_width * scale_value)
		bottom_points.append(p - normal * half_width * scale_value)

	# Build polygon: top edge forward, bottom edge backward
	for p in top_points:
		poly.append(p)
	for i in range(bottom_points.size() - 1, -1, -1):
		poly.append(bottom_points[i])

	body.polygon = poly

# --- temporary squash/stretch ---
func _start_squash_animation(amount: float) -> void:
	stretch_factor = amount
	await get_tree().create_timer(0.1).timeout
	stretch_factor = 0.0
