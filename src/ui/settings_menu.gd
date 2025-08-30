extends Control

@onready var master_label: Label = $VBoxContainer/MasterContainer/MasterLabel
@onready var music_label: Label = $VBoxContainer/MusicContainer/MusicLabel
@onready var sfx_label: Label = $VBoxContainer/SoundEffectsContainer/SfxLabel


func _on_music_slider_value_changed(value: float) -> void:
	Global.music_level = value

func _on_sound_effects_slider_value_changed(value: float) -> void:
	Global.sound_level = value

func _on_master_slider_value_changed(value: float) -> void:
	Global.master_level = value

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().change_scene_to_file(Consts.get_scene_name(Consts.SceneName.MAIN_MENU))
