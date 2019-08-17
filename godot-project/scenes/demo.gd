extends Spatial

onready var camera := $camera
onready var tween := $tween

onready var camera_positions := [$camera_position0, $camera_position1, $camera_position2]

func move_camera(which_position : int) -> void:
	tween.interpolate_property(camera, "transform", camera.transform, camera_positions[which_position].transform, 2.0, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()

func _ready() -> void:
	move_camera(1)