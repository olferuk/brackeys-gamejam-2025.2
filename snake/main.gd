extends Node2D


func _ready():
	var test = $TileMapLayer.get_used_cells()
	$TileMapLayer.set_cell(Vector2i(1, 1), 0, Vector2i(3, 0))
	#for a in test:
		#print(a)``
		#print("image id", $TileMapLayer.get_cell_atlas_coords(a))
	#var pos = $TileMapLayer.get_cell_atlas_coords(Vector2i(0,0))
	#print(pos)
