# Credit: https://youtu.be/HHmH4vwdY7M for transition logic
#         https://youtu.be/TMeT541OLPA for scrolling background

extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var patterns: TextureRect = $Patterns

func _ready() -> void:
	color_rect.visible = false
	patterns.visible = false

func load_scene(scene_name: String) -> void:
	_switch_scene_animated(scene_name)

func reload_scene() -> void:
	_switch_scene_animated()

func _switch_scene_animated(scene_name = null) -> void:
	animation_player.play(&"FadeIn")
	await animation_player.animation_finished
	if scene_name == null:
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file(scene_name)
	animation_player.play_backwards(&"FadeIn")
