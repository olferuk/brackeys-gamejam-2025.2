extends Node

enum SceneName {
	MAIN_MENU,
	SETTINGS,
	LEVEL01,
}

@export_group("Scene Names")
@export var scene_main_menu: String
@export var scene_settings: String
@export var scene_level_01: String

func get_scene_name(scene_name: SceneName) -> String:
	match scene_name:
		SceneName.MAIN_MENU:
			return scene_main_menu
		SceneName.SETTINGS:
			return scene_settings
		SceneName.LEVEL01:
			return scene_level_01
		_:
			return ""
