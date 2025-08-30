class_name Entity
extends Node2D

@export var cell: Vector2i

@export_group("Capabilities")
@export var pushable: bool = false
@export var interactable: bool = false
@export var damaging: bool = false
@export var walkable: bool = true

func _ready() -> void:
	print("Position", MapManager.position_to_cell(position))
	cell = MapManager.position_to_cell(position)
	MapManager.register2(self, cell)

func _on_cell_visited(visited_cell: Vector2i) -> void:
	player_moved()
	if visited_cell == cell:
		trigger()

func trigger() -> void:
	print("Parent")
	pass

func player_moved() -> void:
	pass
#func _enter_tree() -> void:
	#set_meta(&"name", item.name)
#
#func _exit_tree() -> void:
	#remove_meta(&"name")
#
#func register() -> void:
	#MapManager.register(self, cell)

#func shake() -> void:
	## tween for shake
	#pass

func switch_state() -> void:
	$MainStateSprite.visible = !$MainStateSprite.visible
	$AltStateSprite.visible = !$AltStateSprite.visible
