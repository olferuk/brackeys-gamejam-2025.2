extends Entity
class_name ButtonObject
@export var textures: Array[Texture2D] 
@export var hold_press: bool = false
enum State {
	NotPressed,
	Pressed
}

@onready var sprite = $Sprite2D

var current_state: State = State.NotPressed

func _ready() -> void:
	super._ready()

func player_moved() -> void:
	if MapManager.is_occupied_by_dog(cell):
		current_state = State.Pressed
		sprite.texture = textures[current_state]
	else:
		if hold_press:
			current_state = State.NotPressed
			sprite.texture = textures[current_state]

func is_pressed() -> bool:
	return current_state == State.Pressed
