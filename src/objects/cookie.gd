extends Entity

@export var textures: Array[Texture2D] 

func trigger():
	$WinBiinnnn.play()
	$WinCrunch.play()
	SignalBus.starting_to_win.emit()
	
	var tween: Tween = create_tween()
	(
		tween
			.set_ease(Tween.EASE_IN)
			.set_trans(Tween.TRANS_QUAD)
			.tween_property(self, ^"scale", Vector2.ZERO, 0.7)
	)
	await tween.finished
	SignalBus.level_won.emit()
	queue_free()
