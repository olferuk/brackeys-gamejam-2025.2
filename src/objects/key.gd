class_name Key
extends Entity

var collected = false


func trigger():
	if visible:
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
	visible = false
	collected = true

func is_collected() -> bool:
	return collected
