extends Door

@export var buttons: Array[ButtonObject] = []

func _ready() -> void:
	super._ready()

func player_moved() -> void:
	if buttons.is_empty():
		return
	var buttons_pressed = true
	for button in buttons:
		if !button.is_pressed():
			buttons_pressed = false
			break
	if buttons_pressed:
		set_state(State.Opened)
		sprite.texture = textures[State.Opened]
