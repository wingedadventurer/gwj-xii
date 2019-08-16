extends PanelContainer

onready var scene_unit_icon = preload("res://scenes/ui/unit_icon.tscn")

onready var list_units = get_node("vb/units")

func _ready() -> void:
	fill_lists()

func fill_lists() -> void:
	for carrot in get_tree().get_nodes_in_group("carrot"):
		add_icon(list_units, carrot)
	for potato in get_tree().get_nodes_in_group("potato"):
		add_icon(list_units, potato)
	for onion in get_tree().get_nodes_in_group("onion"):
		add_icon(list_units, onion)

func add_icon(list, unit) -> void:
	var unit_icon = scene_unit_icon.instance()
	list.add_child(unit_icon)
	unit_icon.unit = unit
	unit.icon = unit_icon
