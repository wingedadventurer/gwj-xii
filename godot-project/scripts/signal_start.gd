extends Spatial

onready var signal_launcher = $signal_launcher

func spawn_signal() -> void:
	signal_launcher.launch_signal()
