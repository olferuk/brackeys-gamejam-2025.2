extends Control

func _unhandled_input(_event: InputEvent) -> void:
	Transition.load_scene(Consts.get_scene_name(Consts.SceneName.MAIN_MENU))
