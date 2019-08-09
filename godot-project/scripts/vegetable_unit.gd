extends Spatial

var selectable := true setget set_selectable
var selected := false setget set_selected

var highlighted := false setget set_highlighted

func _ready() -> void:
	$select_highlight.material_override = $select_highlight.material_override.duplicate()
	$select_highlight.visible = false

func _physics_process(delta : float) -> void:
	if Input.is_action_just_pressed("select"):
		if highlighted:
			if not selected:
				select()
#		elif selected:
#			deselect()

func set_selectable(value : bool) -> void:
	selectable = value

func set_selected(value : bool) -> void:
	selected = value
	
	$select_highlight.set_rotate(value)
	$select_highlight.visible = value

func set_highlighted(value : bool) -> void:
	highlighted = value
	$select_highlight.visible = value

func select() -> void:
	for unit in get_tree().get_nodes_in_group("unit"):
		unit.set_selected(false)
		unit.set_highlighted(false)
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
