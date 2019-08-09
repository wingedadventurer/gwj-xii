extends Spatial

var scene_camera = preload("res://scenes/camera.tscn")

func _ready() -> void:
	instance_camera()

func instance_camera() -> void:
	var camera = scene_camera.instance()
	add_child(camera)
