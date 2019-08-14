extends Spatial

onready var cam = get_node("pivot/cam")
onready var zoom_tween = get_node("zoom_tween")

var max_move_speed := 8.0
var acceleration_strength := 20.0
var deceleration_factor := 0.2
var zoom := 8.0 setget set_zoom
var min_zoom := 2.0
var max_zoom := 14.0
var zoom_step := 2.0
var zoom_time := 0.6
var camera_drag_movement_factor := 0.01
var camera_drag_rotation_factor := 0.01

var move_velocity : Vector2

var rmb_dragging := false
var mmb_dragging := false

func _ready() -> void:
	set_zoom(zoom)

func _process(delta : float) -> void:
	update_velocity(delta)
	move(move_velocity, delta)
	update_zoom()

func _unhandled_input(event) -> void:
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_RIGHT:
		rmb_dragging = event.pressed
		get_tree().set_input_as_handled()
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_MIDDLE:
		mmb_dragging = event.pressed
		get_tree().set_input_as_handled()
	
	if event is InputEventMouseMotion:
		if rmb_dragging:
			translate(Vector3.LEFT * event.relative.x * camera_drag_movement_factor)
			translate(Vector3.FORWARD * event.relative.y * camera_drag_movement_factor)
		if mmb_dragging:
			rotate_y(-event.relative.x * camera_drag_rotation_factor)

func set_zoom(value : float) -> void:
	zoom = clamp(value, min_zoom, max_zoom)
	
	if zoom_tween:
		zoom_tween.interpolate_property(cam, "transform:origin:z", cam.transform.origin.z, zoom, zoom_time, Tween.TRANS_BACK, Tween.EASE_OUT)
		zoom_tween.start()

func update_zoom() -> void:
	if Input.is_action_just_released("camera_zoom_in"):
		set_zoom(zoom - zoom_step)
	if Input.is_action_just_released("camera_zoom_out"):
		set_zoom(zoom + zoom_step)

func update_velocity(delta : float) -> void:
	var new_move_velocity := Vector2()
	# forward-back movement
	if Input.is_action_pressed("camera_move_forward"):
		new_move_velocity.y += acceleration_strength * delta
	if Input.is_action_pressed("camera_move_back"):
		new_move_velocity.y -= acceleration_strength * delta
	# decelerate if no input
	if new_move_velocity.y == 0.0:
		new_move_velocity.y = -move_velocity.y * deceleration_factor
	
	# left-right movement
	if Input.is_action_pressed("camera_move_left"):
		new_move_velocity.x -= acceleration_strength * delta
	if Input.is_action_pressed("camera_move_right"):
		new_move_velocity.x += acceleration_strength * delta
	# decelerate if no input
	if new_move_velocity.x == 0.0:
		new_move_velocity.x = -move_velocity.x * deceleration_factor
	# limit velocity
	move_velocity = move_velocity.clamped(max_move_speed)
	
	# update velocity
	move_velocity += new_move_velocity

func move(velocity : Vector2, delta : float) -> void:
	translate(Vector3.RIGHT * velocity.x * delta)
	translate(Vector3.FORWARD * velocity.y * delta)
