extends Spatial

var scene_camera = preload("res://scenes/camera.tscn")

var cursor_image = preload("res://textures/cursor_carrot.png")

func _ready() -> void:
	instance_camera()
	Input.set_custom_mouse_cursor(cursor_image)

func instance_camera() -> void:
	var camera = scene_camera.instance()
	add_child(camera)
