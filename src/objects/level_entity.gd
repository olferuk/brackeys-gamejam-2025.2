class_name LevelEntity
extends Node2D

@export var item: Item
@export var cell: Vector2i


func _ready() -> void:
	$MainStateSprite.texture = load(item.sprite_paths[0])
	$AltStateSprite.texture = load(item.sprite_paths[1])

func _enter_tree() -> void:
	set_meta(&"name", item.name)
	
func _exit_tree() -> void:
	remove_meta(&"name")

func register() -> void:
	MapManager.register(self, cell)

func shake() -> void:
	# tween for shake
	pass

func switch_state() -> void:
	$MainStateSprite.visible = !$MainStateSprite.visible
	$AltStateSprite.visible = !$AltStateSprite.visible
