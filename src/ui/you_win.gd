extends Node2D

func popup() -> void:
	visible = true
	$AnimationPlayer.play(&"PopUp")

func _ready() -> void:
	visible = false
	SignalBus.level_won.connect(Callable(self, "popup"))
