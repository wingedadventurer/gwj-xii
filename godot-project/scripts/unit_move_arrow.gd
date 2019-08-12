extends Area
class_name class_move_arrow

signal selected(move_arrow)

export (NodePath) var dependent_move_position = null

var hidden := false
var highlighted := false setget set_highlighted

func _ready() -> void:
	$mesh.scale = Vector3.ZERO
	visible = true
	hidden = true
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
	# don't show if dependent move position is invisible
	if dependent_move_position:
		if get_node(dependent_move_position).hidden:
			return
	
	var is_in_playable_area := false
	
	for area in $free_check_area.get_overlapping_areas():
		if area.is_in_group("move_blocker"):
			return
		if area.is_in_group("playable_area"):
			is_in_playable_area = true
	
	if is_in_playable_area: show2()

func show2() -> void:
	$show_tween.interpolate_property($mesh, "scale", $mesh.scale, Vector3.ONE, 0.2, Tween.TRANS_BACK, Tween.EASE_OUT, rand_range(0.0, 0.1))
	$show_tween.start()
	hidden = false
	input_ray_pickable = true

func hide2() -> void:
	$show_tween.interpolate_property($mesh, "scale", $mesh.scale, Vector3.ZERO, 0.2, Tween.TRANS_CUBIC, Tween.EASE_OUT, rand_range(0.0, 0.1))
	$show_tween.start()
	hidden = true
	input_ray_pickable = false
