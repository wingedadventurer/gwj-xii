extends Spatial
class_name class_farmer

onready var move_tween = $move_tween

var has_waypoints := false
var number_of_waypoints := 0
var current_waypoint_index := 0

func _ready() -> void:
	$move_tween.connect("tween_all_completed", self, "_on_move_tween_completed")
	
	number_of_waypoints = $waypoints.get_child_count()
	if number_of_waypoints > 0: has_waypoints = true
	
	$waypoints.set_as_toplevel(true)

func _process(delta : float) -> void:
	if Input.is_action_just_pressed("ui_home"):
		move_if_has_waypoints()

func move_if_has_waypoints() -> void:
	if has_waypoints:
		move($waypoints.get_child(current_waypoint_index).global_transform.origin)
		current_waypoint_index = wrapi(current_waypoint_index + 1, 0, number_of_waypoints)
	else:
		print("No wp :(")

func has_spotted_unit() -> bool:
	if $unit_detect_area.get_overlapping_areas().size() > 0:
		return true
	return false

func move(new_global_origin : Vector3) -> void:
	look_at(new_global_origin, Vector3.UP)
	var duration = 0.8
	var trans_type = Tween.TRANS_CUBIC
	var ease_type = Tween.EASE_OUT
	var delay = 0.0
	move_tween.interpolate_property(self, "global_transform:origin", global_transform.origin, new_global_origin, duration, trans_type, ease_type, delay)
	move_tween.start()
#	$sfx_move.play()
	if get_node_or_null("model/animation_player"):
		$model/animation_player.play("Move")
		$model/animation_player.queue("Idle")

func _on_move_tween_completed() -> void:
	pass
