extends Spatial
class_name class_level

var scene_camera = preload("res://scenes/camera.tscn")
var cursor_image = preload("res://textures/cursor_carrot.png")

var number_of_celeries := 0
var remaining_celeries := 0

func _ready() -> void:
	instance_camera()
	Input.set_custom_mouse_cursor(cursor_image)
	initialize()

func instance_camera() -> void:
	var camera = scene_camera.instance()
	add_child(camera)

func initialize() -> void:
	# connect celeries
	var celeries = get_tree().get_nodes_in_group("celery")
	for celery in celeries:
		celery.connect("caught_signal", self, "_on_celery_caught_signal")
	
	number_of_celeries = celeries.size()
	reset_remaining_celery_count()

func reset_remaining_celery_count() -> void:
	remaining_celeries = number_of_celeries

func _on_celery_caught_signal(celery : class_celery) -> void:
	remaining_celeries -= 1
	if remaining_celeries == 0:
		win()

func win() -> void:
	for static_ui in get_tree().get_nodes_in_group("static_ui"):
		static_ui.show_win_screen()
