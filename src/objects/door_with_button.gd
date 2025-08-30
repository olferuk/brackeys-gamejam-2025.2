extends Door

@export var buttons: Array[ButtonObject] = []

func _ready() -> void:
	super._ready()

func player_moved() -> void:
	if buttons.is_empty():
		return
	
	var pressed_configuration: Array[int] = []
	var all_buttons_pressed = true
	for button in buttons:
		pressed_configuration.append(int(button.is_pressed()))
		if !button.is_pressed():
			all_buttons_pressed = false
	
	if all_buttons_pressed:
		set_state(State.Opened)
		sprite.texture = textures[State.Opened]
	
	light_indicators(pressed_configuration)

func light_indicators(conf: Array[int]) -> void:
	if conf.count(1) == 2:
		$Lights.visible = false
	elif conf.count(1) == 0:
		$Lights/Left/On.visible = false
		$Lights/Right/On.visible = false
	else:
		$Lights/Left/On.visible = conf[0] == 1
		$Lights/Right/On.visible = conf[1] == 1
