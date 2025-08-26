extends Control

@onready var click_sound: AudioStreamPlayer2D = $ButtonsContainer/ClickSound
@onready var mouse_hover_sound: AudioStreamPlayer2D = $ButtonsContainer/MouseHoverSound


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
