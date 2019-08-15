extends Spatial
class_name class_level

const OBJ_TRANSITION_IN = preload("res://scenes/ui/transition_in.tscn")
const OBJ_LEVEL_INTRO = preload("res://scenes/ui/level_intro.tscn")

onready var canvas = $canvas_layer

export var title := "<level title>"
export var subtitle := "<level subtitle>"

var scene_camera = preload("res://scenes/camera.tscn")
var cursor_image = preload("res://textures/cursor_carrot.png")

export var days_to_harvest := 3 setget set_days_to_harvest
var number_of_celeries := 0
var remaining_celeries := 0

func _ready() -> void:
	instance_camera()
	Input.set_custom_mouse_cursor(cursor_image)
	initialize()
	
	do_transition_in()

func set_days_to_harvest(value : int) -> void:
	days_to_harvest = value
	for static_ui in get_tree().get_nodes_in_group("static_ui"):
		static_ui.set_days_to_harvest(days_to_harvest)
	
func do_transition_in() -> void:
	var transition = OBJ_TRANSITION_IN.instance()
	canvas.add_child(transition)
	transition.free_when_done = true
	transition.connect("transition_done", self, "_on_transition_in_done")
	yield(get_tree().create_timer(1.0), "timeout")
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

func initialize() -> void:
	# connect celeries
	var celeries = get_tree().get_nodes_in_group("celery")
	for celery in celeries:
		celery.connect("caught_signal", self, "_on_celery_caught_signal")
	
	number_of_celeries = celeries.size()
	reset_remaining_celery_count()
	
	for static_ui in get_tree().get_nodes_in_group("static_ui"):
		static_ui.connect("next_turn", self, "_on_next_turn")

func reset_remaining_celery_count() -> void:
	remaining_celeries = number_of_celeries

func win() -> void:
	for static_ui in get_tree().get_nodes_in_group("static_ui"):
		static_ui.show_win_screen()

func lose() -> void:
	for static_ui in get_tree().get_nodes_in_group("static_ui"):
		static_ui.show_lose_screen()

func _on_celery_caught_signal(celery : class_celery) -> void:
	remaining_celeries -= 1
	if remaining_celeries == 0:
		win()

func _on_next_turn(static_ui) -> void:
	if days_to_harvest == 0:
		lose()
		return
	
	set_days_to_harvest(days_to_harvest - 1)

func _on_transition_in_done() -> void:
	yield(get_tree().create_timer(1.5), "timeout")
	set_days_to_harvest(days_to_harvest)
