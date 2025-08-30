extends Node2D

func _ready() -> void:
	SignalBus.level_won.connect(Callable(self, "show_win_banner"))

func show_win_banner():
	var banner := $Sprite2D
	banner.visible = true
	var viewport_size = get_viewport().get_visible_rect().size
	var viewport_postion = get_viewport().get_visible_rect().position
	banner.position = Vector2(viewport_size.x / 2 + 350 / 2, -200)  
	banner.scale = Vector2(0.3, 0.3)

	var tween := create_tween()
	# Drop into center with bounce
	tween.tween_property(banner, "position:y", viewport_size.y/2 - 100, 0.9)\
		.set_trans(Tween.TRANS_BOUNCE)\
		.set_ease(Tween.EASE_OUT)
	# Scale up with squash
	tween.tween_property(banner, "scale", Vector2(0.5, 0.5), 0.5)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
