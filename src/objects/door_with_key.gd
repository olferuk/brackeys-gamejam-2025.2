extends Door

@export var keys: Array[Key] = []

func player_moved() -> void:
	if keys.is_empty():
		return
	var keys_collected = true
	for key in keys:
		if (key != null) and !key.is_collected():
			keys_collected = false
			break
	if keys_collected:
		if MapManager.in_range_of_dog(cell, 1):
			set_state(State.Opened)
			sprite.texture = textures[State.Opened]
