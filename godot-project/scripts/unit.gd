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
		
		if $model/animation_player:
			$model/animation_player.set_blend_time("Rise", "Idle", 0.2)

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
	if $model/animation_player:
		$model/animation_player.play("Bury")
	$sfx_bury.play()

func unbury() -> void:
	buried = false
	if $model/animation_player:
		$model/animation_player.play("Rise")
		$model/animation_player.queue("Idle")
	$sfx_unbury.play(0.0)
