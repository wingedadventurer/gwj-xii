extends Spatial
class_name class_level

signal farmers_done

const OBJ_TRANSITION_IN = preload("res://scenes/ui/transition_in.tscn")
const OBJ_LEVEL_INTRO = preload("res://scenes/ui/level_intro.tscn")
const OBJ_PAUSE_SCREEN = preload("res://scenes/ui/menus/pause_screen.tscn")
var scene_camera = preload("res://scenes/camera.tscn")
var cursor_image = preload("res://textures/cursor_carrot.png")
const SCENE_GRASS_PLANE = preload("res://scenes/grass_plane.tscn")

onready var canvas = $canvas_layer

export var title := "<level title>"
export var subtitle := "<level subtitle>"
export var days_to_harvest := 3
export (String, MULTILINE) var level_hint = ""
# warning-ignore:unused_class_variable
export (PackedScene) var next_level = null
export var last := false
var number_of_celeries := 0
var remaining_celeries := 0
var farmers_queue := []

func _ready() -> void:
	settings.apply_settings()
	instance_camera()
	Input.set_custom_mouse_cursor(cursor_image)
	initialize()
	do_transition_in()
	$camera_limit_top_left.visible = false
	$camera_limit_bottom_right.visible = false
	if last:
		audio_manager.play_music(2)
		audio_manager.stop_ambience()
	else:
		audio_manager.play_music(1)
		audio_manager.play_ambience()

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
	camera.move_to_transform($camera_start_position.transform)
	add_child(camera)
	camera.limit_top_left = $camera_limit_top_left
	camera.limit_bottom_right = $camera_limit_bottom_right

func initialize() -> void:
	# connect celeries
	var celeries = get_tree().get_nodes_in_group("celery")
	for celery in celeries:
		celery.connect("caught_signal", self, "_on_celery_caught_signal")
	
	number_of_celeries = celeries.size()
	reset_remaining_celery_count()
	
	for static_ui in get_tree().get_nodes_in_group("static_ui"):
		static_ui.connect("next_turn", self, "_on_next_turn")
		static_ui.set_level_hint(level_hint)
	
	for farmer in get_tree().get_nodes_in_group("farmer"):
		farmer.connect("action_done", self, "_on_farmer_action_done")
	
	# add grass plane
	var grass_plane = SCENE_GRASS_PLANE.instance()
	add_child(grass_plane)

func reset_remaining_celery_count() -> void:
	remaining_celeries = number_of_celeries

func win() -> void:
	for static_ui in get_tree().get_nodes_in_group("static_ui"):
		static_ui.show_win_screen()

func lose(reason := -1) -> void:
	deselect_all_units()
	for static_ui in get_tree().get_nodes_in_group("static_ui"):
		static_ui.disable_buttons()
		static_ui.show_lose_screen(reason)
	for unit_ui in get_tree().get_nodes_in_group("unit_ui"):
		(unit_ui as class_unit_ui).hide()

func deselect_all_units() -> void:
	for unit in get_tree().get_nodes_in_group("unit"):
		(unit as class_unit).deselect()
		(unit as class_unit).set_highlighted(false)

func are_farmers_seeing_unit() -> bool:
	for farmer in get_tree().get_nodes_in_group("farmer"):
		if (farmer as class_farmer).has_spotted_unit():
			return true
	return false

func _on_celery_caught_signal(celery : class_celery) -> void:
	remaining_celeries -= 1
	if remaining_celeries == 0:
		win()

func _on_next_turn(static_ui) -> void:
	# deselect units
	deselect_all_units()
	for unit_ui in get_tree().get_nodes_in_group("unit_ui"):
		unit_ui.hide()
	
	# disable buttons
	for static_ui in get_tree().get_nodes_in_group("static_ui"):
		static_ui.disable_buttons()
	
	# reset stuff
	for unit in get_tree().get_nodes_in_group("unit"): unit.reset()
	for celery in get_tree().get_nodes_in_group("celery"): celery.reset()
	reset_remaining_celery_count()
	
	# lose if no more days
	if days_to_harvest == 0:
		lose(0)
		return
	
	# lose if farmers are seeing any units atm
	if are_farmers_seeing_unit():
		lose(1)
		return
	
	# fill farmers queue
	farmers_queue = get_tree().get_nodes_in_group("farmer")
	if farmers_queue.size() > 0:
		farmers_queue[0].do_action()
		yield(self, "farmers_done")
	else:
		enable_all_controls()
	
	for unit in get_tree().get_nodes_in_group("unit"):
		unit.set_action_done(false)
	
	# update days to harvest
	set_days_to_harvest(days_to_harvest - 1)

func _on_transition_in_done() -> void:
	yield(get_tree().create_timer(1.5), "timeout")
	set_days_to_harvest(days_to_harvest)

func _on_farmer_action_done(farmer : class_farmer) -> void:
	# check if spotted now
	if farmer.has_spotted_unit():
		lose(0)
		return
	
	# move onto next farmer in queue, or complete
	if farmer in farmers_queue:
		farmers_queue.pop_front()
		if farmers_queue.size() > 0:
			(farmers_queue[0] as class_farmer).do_action()
		else:
			emit_signal("farmers_done")
			enable_all_controls()

func enable_all_controls() -> void:
	for static_ui in get_tree().get_nodes_in_group("static_ui"):
		static_ui.enable_buttons()

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var pause = OBJ_PAUSE_SCREEN.instance()
		add_child(pause)
