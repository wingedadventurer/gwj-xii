extends Spatial

onready var signal_launcher = $signal_launcher
onready var model = $model_thunder

var particles_rotate_speed := 120.0

func _ready() -> void:
	$particles_pivot.visible = true
	$model_thunder.visible = true
	model.visible = false

func _process(delta) -> void:
	$particles_pivot.rotation_degrees.y += particles_rotate_speed * delta

func spawn_signal() -> void:
	model.visible = true
	signal_launcher.launch_signal()
	$model_thunder/thunder_pivot.rotation_degrees.y = rand_range(0.0, 360.0)
	for m in $model_thunder/thunder_pivot.get_children():
		$thunder_tween.interpolate_property(m, "material_override:albedo_color:a", 1.0, 0.0, 0.8, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$thunder_tween.start()
	$sfx_start_signal.play()
