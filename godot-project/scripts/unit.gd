tool
extends Spatial
class_name class_unit

export var buried := true

var selectable := true setget set_selectable
var highlighted := false setget set_highlighted
var selected := false setget set_selected
# warning-ignore:unused_class_variable
var unit_type := 0

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
		
		hide_move_arrows()
		
		for move_arrow in $move_positions.get_children():
			move_arrow.connect("selected", self, "_on_move_arrow_selected")

func _unhandled_input(event) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed == true and highlighted:
		get_tree().set_input_as_handled()
		if not selected:
			select()
			for unit_ui in get_tree().get_nodes_in_group("unit_ui"):
				unit_ui.display_unit(self)

func set_selectable(value : bool) -> void:
	selectable = value

func set_selected(value : bool) -> void:
	selected = value
	
	$select_highlight.set_rotate(value)
	$select_highlight.visible = value
	if value == true: $sfx_select.play()
	hide_move_arrows()

func set_highlighted(value : bool) -> void:
	highlighted = value
	$select_highlight.visible = value

func select() -> void:
	for unit in get_tree().get_nodes_in_group("unit"):
		unit.set_selected(false)
		unit.set_highlighted(false)
	for unit_ui in get_tree().get_nodes_in_group("unit_ui"):
		unit_ui.show()
	
	set_highlighted(false)
	set_selected(true)

func deselect() -> void:
	set_selected(false)

func _on_mouse_detect_area_mouse_entered() -> void:
	if not selected:
		set_highlighted(true)

func _on_mouse_detect_area_mouse_exited() -> void:
	if not selected:
		set_highlighted(false)

func bury() -> void:
	buried = true
	if get_node_or_null("model/animation_player"):
		$model/animation_player.play("Bury")
	$sfx_bury.play()
	hide_move_arrows()
	deselect()

func unbury() -> void:
	buried = false
	if get_node_or_null("model/animation_player"):
		$model/animation_player.play("Rise")
		$model/animation_player.queue("Idle")
	$sfx_unbury.play(0.0)
	deselect()

func show_move_arrows() -> void:
	for node in $move_positions.get_children():
		node.show_if_free()

func hide_move_arrows() -> void:
	for node in $move_positions.get_children():
		node.visible = false

func _on_move_arrow_selected(move_arrow : class_move_arrow) -> void:
	move(move_arrow.global_transform.origin)
	for unit_ui in get_tree().get_nodes_in_group("unit_ui"):
		unit_ui.hide()
	deselect()

func move(new_global_origin : Vector3) -> void:
#	$model.look_at_from_position(new_global_origin, global_transform.origin, Vector3.UP)
	var duration := 1.2
	var trans_type := Tween.TRANS_EXPO
	var ease_type := Tween.EASE_OUT
	var delay := 0.3
	$move_tween.interpolate_property(self, "global_transform:origin", global_transform.origin, new_global_origin, duration, trans_type, ease_type, delay)
	$move_tween.start()
	$sfx_move.play()
	if get_node_or_null("model/animation_player"):
		$model/animation_player.play("Move")
		$model/animation_player.queue("Idle")
