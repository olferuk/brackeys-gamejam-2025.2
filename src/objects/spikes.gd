extends Entity
class_name Spikes

@export var textures: Array[Texture2D]

@onready var sprite = $Sprite2D
@export var _moving = false
@export var _hidden = false

func _ready() -> void:
	super._ready()

func player_moved() -> void:
	if _moving:
		_hidden = !_hidden
	if _hidden:
		sprite.texture = textures[0]
	else:
		sprite.texture = textures[1]
	if MapManager.is_occupied_by_dog(cell) and !_hidden:
		SignalBus.emit_signal("level_lost")
