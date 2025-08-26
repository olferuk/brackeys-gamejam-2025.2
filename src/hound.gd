class_name Hound
extends Node2D

@onready var body_sections: Node2D = $BodySections
@onready var dog_body_layer: TileMapLayer = $DogBodyLayer

@export var body_schema: BodySchema

enum SectionType {
	HEAD,
	TAIL,
	BODY
}

var is_moving: bool = false

func _ready() -> void:
	var x := 0.
	for t in [SectionType.TAIL, SectionType.BODY, SectionType.HEAD]:
		_add_section(t, Vector2(x*Global.cell_size, 0), Vector2i.RIGHT)
		x += 1

func _unhandled_input(event: InputEvent) -> void:
	if is_moving:
		return
	
	var dir := Vector2i.ZERO
	if event.is_action_pressed("move_up"): 
		dir = Vector2i(0, -1)
		print("^")
	elif event.is_action_pressed("move_down"):
		dir = Vector2i(0, 1)
		print("v")
	elif event.is_action_pressed("move_left"):
		dir = Vector2i(-1, 0)
		print("<")
	elif event.is_action_pressed("move_right"):
		dir = Vector2i(1, 0)
		print(">")

	if dir != Vector2i.ZERO:
		#move_forward(dir)
		pass
#
	#if event.is_action_pressed("stretch"): stretch()
	#elif event.is_action_pressed("shrink"): shrink()

func _add_section(section_type: SectionType, spawn_at: Vector2, orient_towards: Vector2i):
	push_warning(section_type, spawn_at, orient_towards)
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
