extends Spatial

var max_move_speed := 10.0
var acceleration_strength := 40.0
var deceleration_factor := 0.2

var move_velocity : Vector2

func _process(delta : float) -> void:
	check_input_and_update_velocity(delta)
	move(move_velocity, delta)

func check_input_and_update_velocity(delta : float) -> void:
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
	transform.origin.x += velocity.x * delta
	transform.origin.z -= velocity.y * delta
