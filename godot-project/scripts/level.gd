extends Spatial

const OBJ_TRANSITION_IN = preload("res://scenes/ui/transition_in.tscn")
const OBJ_LEVEL_INTRO = preload("res://scenes/ui/level_intro.tscn")

onready var canvas = $canvas_layer

export var title := "<level title>"
export var subtitle := "<level subtitle>"

var scene_camera = preload("res://scenes/camera.tscn")

var cursor_image = preload("res://textures/cursor_carrot.png")

func _ready() -> void:
	instance_camera()
	Input.set_custom_mouse_cursor(cursor_image)
	do_transition_in()

func do_transition_in() -> void:
	var transition = OBJ_TRANSITION_IN.instance()
	add_child(transition)
	transition.do_transition()
	do_level_intro()

func do_level_intro() -> void:
	var level_intro = OBJ_LEVEL_INTRO.instance()
	canvas.add_child(level_intro)
	level_intro.set_intro_text(title, subtitle)
	level_intro.do_intro()

func instance_camera() -> void:
	var camera = scene_camera.instance()
	add_child(camera)
