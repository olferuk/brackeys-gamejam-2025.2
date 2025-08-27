extends Control

@onready var click_sound: AudioStreamPlayer2D = $ButtonsContainer/ClickSound
@onready var mouse_hover_sound: AudioStreamPlayer2D = $ButtonsContainer/MouseHoverSound

@onready var new_game: Button = $ButtonsContainer/VBoxContainer/NewGame
@onready var settings: Button = $ButtonsContainer/VBoxContainer/Settings
@onready var exit: Button = $ButtonsContainer/VBoxContainer/Exit

var tween: Tween

func _ready() -> void:
	new_game.pivot_offset = new_game.size / 2.
	settings.pivot_offset = settings.size / 2.
	exit.pivot_offset = exit.size / 2.
	
	new_game.mouse_entered.connect(_on_mouse_entered.bind(new_game))
	settings.mouse_entered.connect(_on_mouse_entered.bind(settings))
	exit.mouse_entered.connect(_on_mouse_entered.bind(exit))
	
	new_game.mouse_exited.connect(_on_mouse_exited.bind(new_game))
	settings.mouse_exited.connect(_on_mouse_exited.bind(settings))
	exit.mouse_exited.connect(_on_mouse_exited.bind(exit))

func _on_mouse_entered(btn: Button) -> void:
	_reset_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(btn, ^"scale", Vector2(1.1, 1.1), 0.4)

func _on_mouse_exited(btn: Button) -> void:
	_reset_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(btn, ^"scale", Vector2.ONE, 0.4)

func _reset_tween() -> void:
	if tween:
		tween.kill()
	tween = create_tween()

func _on_new_game_pressed() -> void:
	play_sound(click_sound)
	Transition.load_scene(Consts.get_scene_name(Consts.SceneName.LEVEL01))

func _on_settings_pressed() -> void:
	play_sound(click_sound)
	#Transition.load_scene(Consts.get_scene_name(Consts.SceneName.SETTINGS))
	get_tree().change_scene_to_file(Consts.get_scene_name(Consts.SceneName.SETTINGS))

func _on_exit_pressed() -> void:
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func _on_new_game_mouse_entered() -> void:
	play_sound(mouse_hover_sound)

func _on_settings_mouse_entered() -> void:
	play_sound(mouse_hover_sound)

func _on_exit_mouse_entered() -> void:
	play_sound(mouse_hover_sound)

func play_sound(stream: AudioStreamPlayer2D):
	if stream.playing:
		stream.stop()
	stream.play()
