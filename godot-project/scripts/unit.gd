tool
extends Spatial
class_name class_unit

onready var move_tween = $move_tween
onready var turn_tween = $turn_tween

export var buried := true

var selectable := true setget set_selectable
var highlighted := false setget set_highlighted
var selected := false setget set_selected
var unit_type := 0
var action_done := false setget set_action_done
var signals_launched := false

var icon : class_unit_icon = null
var rot := 0.0 setget set_rot

var move_tween_values := {
	0: {},
	1: {
		"duration": 1.2,
		"delay": 0.3,
		"trans_type": Tween.TRANS_EXPO,
		"ease_type": Tween.EASE_OUT,
	},
	2: {
		"duration": 1.3,
		"delay": 0.5,
		"trans_type": Tween.TRANS_SINE,
		"ease_type": Tween.EASE_OUT_IN,
	},
	3: {
		"duration": 1.2,
		"delay": 0.3,
		"trans_type": Tween.TRANS_EXPO,
		"ease_type": Tween.EASE_OUT,
	},
}

func _ready() -> void:
	if Engine.editor_hint:
		pass
	else:
		$select_highlight.material_override = $select_highlight.material_override.duplicate()
		$select_highlight.visible = false
		if buried: bury()
		else: unbury()
		
		if get_node_or_null("model/animation_player"):
			$model/animation_player.set_blend_time("Rise", "Idle", 0.1)
			$model/animation_player.set_blend_time("Move", "Idle", 0.1)
		
		for move_arrow in $move_positions.get_children():
			move_arrow.connect("selected", self, "_on_move_arrow_selected")
		
		set_action_done(false)
		
		icon.call_deferred("update_icon")
	
		set_rot(rot)

func _unhandled_input(event) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed == true and highlighted:
		get_tree().set_input_as_handled()
		if not selected:
			select()

func set_rot(value : float) -> void:
	rot = value
	
	turn_tween.interpolate_property($model, "rotation_degrees:y", $model.rotation_degrees.y, rot, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	turn_tween.start()
	
	$signal_launchers.rotation_degrees.y = rot + 180.0

func set_action_done(value : bool) -> void:
	if value:
		$action_indicator/animation_player.play("hide")
	else:
		$action_indicator/animation_player.play("show")
		$action_indicator/animation_player.queue("idle")
	
	action_done = value
	if icon: icon.update_icon()

func set_selectable(value : bool) -> void:
	selectable = value

func set_selected(value : bool) -> void:
	$select_highlight.set_rotate(value)
	$select_highlight.visible = value
	if value == true: $sfx_select.play()
	if value == false:
		hide_move_arrows()
	
	selected = value
	if icon: icon.update_icon()

func set_highlighted(value : bool) -> void:
	highlighted = value
	$select_highlight.visible = value

func select() -> void:
	for unit in get_tree().get_nodes_in_group("unit"):
		if unit != self:
			unit.deselect()
			unit.set_highlighted(false)
	for unit_ui in get_tree().get_nodes_in_group("unit_ui"):
		unit_ui.show()
		unit_ui.display_unit(self)
	
	set_highlighted(false)
	set_selected(true)
	
	# show move arrows
	if not action_done and not buried:
		show_move_arrows()

func deselect() -> void:
	set_selected(false)

func _on_mouse_detect_area_mouse_entered() -> void:
	if not selected and not action_done:
		set_highlighted(true)

func _on_mouse_detect_area_mouse_exited() -> void:
	if not selected:
		set_highlighted(false)

func show_move_arrows() -> void:
	for node in $move_positions.get_children():
		node.show_if_free()
	print("Shown move arrows!")

func hide_move_arrows() -> void:
	for node in $move_positions.get_children():
		node.hide2()
	print("Hidden move arrows!")

func _on_move_arrow_selected(move_arrow : class_move_arrow) -> void:
	move(move_arrow.global_transform.origin)
	for unit_ui in get_tree().get_nodes_in_group("unit_ui"):
		unit_ui.hide()
	deselect()

func move(new_global_origin : Vector3) -> void:
	var duration = move_tween_values[unit_type]["duration"]
	var trans_type = move_tween_values[unit_type]["trans_type"]
	var ease_type = move_tween_values[unit_type]["ease_type"]
	var delay = move_tween_values[unit_type]["delay"]
	move_tween.interpolate_property(self, "global_transform:origin", global_transform.origin, new_global_origin, duration, trans_type, ease_type, delay)
	move_tween.start()
	$sfx_move.play()
	if get_node_or_null("model/animation_player"):
		$model/animation_player.play("Move")
		$model/animation_player.queue("Idle")
	set_action_done(true)

func bury() -> void:
	buried = true
	if get_node_or_null("model/animation_player"):
		$model/animation_player.play("Bury")
	$sfx_bury.play()
	hide_move_arrows()
	deselect()
	set_action_done(true)
	if icon: icon.update_icon()

func unbury() -> void:
	buried = false
	if get_node_or_null("model/animation_player"):
		$model/animation_player.play("Rise")
		$model/animation_player.queue("Idle")
	$sfx_unbury.play(0.0)
	deselect()
	set_action_done(true)
	if icon: icon.update_icon()

func launch_signals() -> void:
	for signal_launcher in $signal_launchers.get_children():
		signal_launcher.launch_signal()
	$sfx_signal_bounce.play()

func _on_signal_receive_area_body_entered(body):
	if signals_launched: return
	
	# consume signal
	if body is class_signal:
		body.queue_free()
	
	# propagate signal if buried
	if not buried: return
	signals_launched = true
	launch_signals()

func turn(cw := true) -> void:
	if cw: set_rot(rot - 90.0)
	else: set_rot(rot + 90.0)
