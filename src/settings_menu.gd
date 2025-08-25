extends Control

@onready var master_label: Label = $VBoxContainer/MasterContainer/MasterLabel
@onready var music_label: Label = $VBoxContainer/MusicContainer/MusicLabel
@onready var sfx_label: Label = $VBoxContainer/SoundEffectsContainer/SfxLabel


func _on_music_slider_value_changed(value: float) -> void:
	Global.musicLevel = value

func _on_sound_effects_slider_value_changed(value: float) -> void:
	Global.soundLevel = value

func _on_master_slider_value_changed(value: float) -> void:
	Global.masterLevel = value
