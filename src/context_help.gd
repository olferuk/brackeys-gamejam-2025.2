extends HBoxContainer

var tween: Tween

@export var time: float = .4
@export var amplitude: float = .08

func _ready() -> void:
	pivot_offset = size / 2.
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($".", ^"scale", Vector2(1+amplitude, 1+amplitude), time)
	tween.tween_property($".", ^"scale", Vector2(1-amplitude, 1-amplitude), time)
	tween.set_loops(0)
