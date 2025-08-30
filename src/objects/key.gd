extends Entity

func trigger():
	$CollectSound.play()
	var tween: Tween = create_tween()
	(
		tween
			.set_ease(Tween.EASE_IN)
			.set_trans(Tween.TRANS_QUAD)
			.tween_property(self, ^"scale", Vector2.ZERO, 0.4)
	)
	await tween.finished
	print("Key collected")
	queue_free()
