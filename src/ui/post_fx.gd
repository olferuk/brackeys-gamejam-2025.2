extends CanvasLayer

@onready var mat: ShaderMaterial = $ColorRect.material
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	$Label.pivot_offset = $Label.size / 2.

func play_postfx(duration_sec: float = 1.) -> void:
	mat.set_shader_parameter("animation_len", duration_sec)
	mat.set_shader_parameter("is_active", true)
	mat.set_shader_parameter("start_time", Time.get_ticks_msec() / 1000.0)
	audio_stream_player.play()
	$Label.visible = true
	$AnimationPlayer.play(&"pop_up")

func stop_postfx() -> void:
	mat.set_shader_parameter("is_active", false)
	$Label.visible = false
