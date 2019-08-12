extends Spatial

onready var signal_launcher = $signal_launcher
onready var model = $model_thunder

func _ready() -> void:
	model.visible = false

func spawn_signal() -> void:
	model.visible = true
	signal_launcher.launch_signal()
	$model_thunder/thunder_pivot.rotation_degrees.y = rand_range(0.0, 360.0)
	for m in $model_thunder/thunder_pivot.get_children():
		$thunder_tween.interpolate_property(m, "material_override:albedo_color:a", 1.0, 0.0, 0.8, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$thunder_tween.start()
	$sfx_start_signal.play()
