extends Node

var player: Hound
var map: TileMapLayer
var level: int = 1
var dog_head_shift: Vector2i = Vector2i.ZERO

var level_objects: Dictionary[Vector2i, LevelEntity]
var level_entites: Dictionary[Vector2i, Entity]

func _real_cell(cell: Vector2i) -> Vector2i:
	# CELL is dog-first coordinate system
	# REAL CELL is map-first
	return cell + dog_head_shift

#func register(entity: LevelEntity, cell: Vector2i) -> void: 
	#level_objects[cell] = entity

func register2(entity: Entity, cell: Vector2i) -> void: 
	SignalBus.cell_visited.connect(entity._on_cell_visited)
	level_entites[cell] = entity

func is_walkable(cell: Vector2i) -> bool:
	var tile_data: TileData = map.get_cell_tile_data(_real_cell(cell))
	if tile_data == null:
		push_warning("Sky tile taken probably; check dog_head_shift value! Got cell ", cell, " and head shift of ", dog_head_shift)
		return false
	else:
		var walkable: bool = tile_data.get_custom_data("walkable") as bool
		if not walkable:
			return walkable
		var obj = level_objects.get(_real_cell(cell))
		if obj == null:
			return true
		return (obj as LevelEntity).pushable

func visit(cell: Vector2i):
	SignalBus.cell_visited.emit(_real_cell(cell))

func get_entitity(cell: Vector2i) -> Node:
	return level_entites[cell]
	
func position_to_cell(position: Vector2i) -> Vector2i:
	position = position / int(Global.cell_size)
	return Vector2i(position.x, position.y)
