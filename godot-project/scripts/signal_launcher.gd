extends Position3D

export (float) var velocity = 5.0

var scene_signal = load("res://scenes/signal.tscn")

func _ready() -> void:
	$temp_arrow.queue_free()

func launch_signal() -> void:
	var s = scene_signal.instance()
	s.global_transform = global_transform
	s.set_axis_velocity(-global_transform.basis.z * velocity)
	get_tree().current_scene.add_child(s)
