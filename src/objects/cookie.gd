extends Sprite2D

@export var textures: Array[Texture2D] 

func _ready() -> void:
	$Snack.texture = textures[0]

func eaten():
	$WinBiinnnn.play()
	$WinCrunch.play()
	
	$Snack.texture = textures[1]
	
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
