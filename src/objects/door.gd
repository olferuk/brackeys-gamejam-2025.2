extends Entity
class_name Door

@export var textures: Array[Texture2D] 
enum State {
	Closed,
	Opened
}

@onready var sprite = $Sprite2D

var current_state: State = State.Closed

func _ready() -> void:
	super._ready()

func player_moved() -> void:
	pass
	#if MapManager.is_occupied_by_dog(cell):
		#current_state = State.Pressed
		#sprite.texture = textures[current_state]
	#else:
		#current_state = State.NotPressed
		#sprite.texture = textures[current_state]

func is_openned() -> bool:
	return current_state == State.Opened

func set_state(state:State):
	current_state = state
	if current_state == State.Opened:
		walkable = true
	if current_state == State.Closed:
		walkable = false
