tool
extends Spatial
class_name class_unit

var selectable := true setget set_selectable
var selected := false setget set_selected

var highlighted := false setget set_highlighted

export (int, "NONE", "CARROT", "POTATO") var unit_type setget set_unit_type
export var buried := true

func _ready() -> void:
	if Engine.editor_hint:
		pass
	else:
		$select_highlight.material_override = $select_highlight.material_override.duplicate()
		$select_highlight.visible = false
		$model_carrot/animation_player.play("Bury")

func _physics_process(delta : float) -> void:
	if Engine.editor_hint:
		pass
	else:
		if Input.is_action_just_pressed("select"):
			if highlighted:
				if not selected:
					select()
					for unit_ui in get_tree().get_nodes_in_group("unit_ui"):
						unit_ui.display_unit(self)

func set_unit_type(value : int) -> void:
	unit_type = value
	
	if $model_carrot and $mesh_potato_temp:
		$model_carrot.visible = false
		$mesh_potato_temp.visible = false
		match unit_type:
			1:
				$model_carrot.visible = true
			2:
				$mesh_potato_temp.visible = true

func set_selectable(value : bool) -> void:
	selectable = value

func set_selected(value : bool) -> void:
	selected = value
	
	$select_highlight.set_rotate(value)
	$select_highlight.visible = value
	$sfx_select.play()

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
	$model_carrot/animation_player.play("Bury")

func unbury() -> void:
	buried = false
	$model_carrot/animation_player.play("Rise")
