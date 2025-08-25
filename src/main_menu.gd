extends Control

@onready var mouse_hover_sound: AudioStreamPlayer2D = $ButtonsContainer/MouseHoverSound
@onready var click_sound: AudioStreamPlayer2D = $ButtonsContainer/ClickSound


func _on_new_game_pressed() -> void:
	play_sound(click_sound)

func _on_settings_pressed() -> void:
	play_sound(click_sound)

func _on_exit_pressed() -> void:
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
