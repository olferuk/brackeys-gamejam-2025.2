extends Node2D

func popup() -> void:
	visible = true
	$AnimationPlayer.play(&"PopUp")

func _ready() -> void:
	visible = false
	SignalBus.starting_to_win.connect(Callable(self, "popup"))
