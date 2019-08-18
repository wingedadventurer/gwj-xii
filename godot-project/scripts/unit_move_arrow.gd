extends Area
class_name class_move_arrow

signal selected(move_arrow)

export (NodePath) var next_position = null

var highlighted := false setget set_highlighted

func _ready() -> void:
	visible = true
	$free_check_area.visible = false
	input_ray_pickable = false

func _unhandled_input(event) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed == true and highlighted:
		emit_signal("selected", self)
		get_tree().set_input_as_handled()

func set_highlighted(value : bool) -> void:
	highlighted = value

func _on_unit_move_arrow_mouse_entered() -> void:
	set_highlighted(true)

func _on_unit_move_arrow_mouse_exited() -> void:
	set_highlighted(false)

func show_if_free() -> void:
	var in_playable_area := false
	var jump_blocked := false
	var move_blocked := false

	# check if in playable area
	for area in $free_check_area.get_overlapping_areas():
		if area.is_in_group("playable_area"):
			in_playable_area = true
			break

	# check if jump blocked
	for area in $free_check_area.get_overlapping_areas():
		if area.is_in_group("jump_blocker"):
			jump_blocked = true
			break

	# check if move blocked
	for area in $free_check_area.get_overlapping_areas():
		if area.is_in_group("move_blocker"):
			move_blocked = true
			break

	# process
	if not in_playable_area: return
	if next_position:
		if jump_blocked:
			return
		else:
			get_node(next_position).show_if_free()
	if move_blocked:
		return
	
	appear()

func appear() -> void:
	$show_tween.interpolate_property($mesh, "scale", $mesh.scale, Vector3.ONE, 0.2, Tween.TRANS_BACK, Tween.EASE_OUT, rand_range(0.0, 0.1))
	$show_tween.start()
	input_ray_pickable = true

func disappear() -> void:
#	$show_tween.interpolate_property($mesh, "scale", $mesh.scale, Vector3.ZERO, 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT, rand_range(0.0, 0.1))
#	$show_tween.start()
	$mesh.scale = Vector3.ZERO
	input_ray_pickable = false
