extends Node

enum SceneName {
	MAIN_MENU,
	SETTINGS
}

@export_group("Scene Names")
@export var scene_main_menu: String
@export var scene_settings: String

func get_scene_name(scene_name: SceneName) -> String:
	match scene_name:
		SceneName.MAIN_MENU:
			return scene_main_menu
		SceneName.SETTINGS:
			return scene_settings
		_:
			return ""
