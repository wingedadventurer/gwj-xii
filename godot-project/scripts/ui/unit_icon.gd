extends TextureButton
class_name class_unit_icon

var unit_icons := {
	0: null,
	1: preload("res://textures/unit_icons/icon_carrot.png"),
	2: preload("res://textures/unit_icons/icon_potato.png"),
	3: preload("res://textures/unit_icons/icon_onion.png"),
}

var unit = null

func _ready() -> void:
	if unit:
		texture_normal = unit_icons[unit.unit_type]

func update_icon() -> void:
	if not unit: return
	
	texture_normal = unit_icons[unit.unit_type]
	$selected.visible = unit.selected
	if unit.action_done:
		self_modulate.a = 0.2
	else:
		self_modulate.a = 1.0

func _on_unit_icon_pressed() -> void:
	if not unit: return
	if unit.action_done: return
	unit.select()
