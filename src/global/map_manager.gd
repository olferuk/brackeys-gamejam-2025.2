extends Node

var player: Hound
var map: TileMapLayer
var level: int = 1
var dog_head_shift: Vector2i = Vector2i.ZERO

var level_objects: Dictionary[Vector2i, LevelEntity]

func _real_cell(cell: Vector2i) -> Vector2i:
	# CELL is dog-first coordinate system
	# REAL CELL is map-first
	return cell + dog_head_shift

func register(entity: LevelEntity, cell: Vector2i) -> void: 
	level_objects[cell] = entity

func is_walkable(cell: Vector2i) -> bool:
	var tile_data: TileData = map.get_cell_tile_data(_real_cell(cell))
	var walkable: bool = tile_data.get_custom_data("walkable") as bool
	if not walkable:
		return walkable
	var obj = level_objects.get(_real_cell(cell))
	if obj == null:
		return true
	return (obj as LevelEntity).pushable

func visit(cell: Vector2i):
	SignalBus.cell_visited.emit(_real_cell(cell))

#func get_entities(cell: Vector2i) -> Node:
	#return Node.new()
