extends Control
class_name class_unit_ui

onready var unit_name = $p/vb/hb/unit_name
onready var unit_profile = $p/vb/unit_background/unit_profile
onready var button_bury_unbury = $p_2/vb/vb/button_bury_unbury
onready var button_turn_left = $p_2/vb/vb/hb/button_turn_left
onready var button_turn_right = $p_2/vb/vb/hb/button_turn_right

var unit_profiles := {
	UNIT_NONE: preload("res://textures/unit_profiles/profile_empty.png"),
	UNIT_CARROT: preload("res://textures/unit_profiles/profile_carrot.png"),
	UNIT_POTATO: preload("res://textures/unit_profiles/profile_potato.png"),
	UNIT_ONION: preload("res://textures/unit_profiles/profile_onion.png"),
}

var unit_names := {
	UNIT_NONE: "None",
	UNIT_CARROT: "Carrot",
	UNIT_POTATO: "Potato",
	UNIT_ONION: "Onion",
}

const UNIT_NONE := 0
const UNIT_CARROT := 1
const UNIT_POTATO := 2
const UNIT_ONION := 3

var selected_unit : class_unit = null

func display_unit(unit : class_unit) -> void:
	show()
	selected_unit = unit
	unit_name.text = unit_names[unit.unit_type]
	unit_profile.texture = unit_profiles[unit.unit_type]
	enable_appropriate_actions()

func _ready() -> void:
	disable_all_actions()
	hide()

func disable_all_actions() -> void:
	button_bury_unbury.disabled = true
	button_turn_left.disabled = true
	button_turn_right.disabled = true

func enable_appropriate_actions() -> void:
	disable_all_actions()
	if selected_unit:
		button_bury_unbury.disabled = false
		if selected_unit.buried:
			button_bury_unbury.text = "Unbury"
		else:
			button_bury_unbury.text = "Bury"
		
		# enable rotation if not buried
		if not selected_unit.buried:
			button_turn_left.disabled = false
			button_turn_right.disabled = false

func _on_button_close_pressed() -> void:
	if selected_unit:
		selected_unit.deselect()
	hide()

func _on_button_turn_left_pressed() -> void:
	if selected_unit:
		selected_unit.turn(false)

func _on_button_turn_right_pressed() -> void:
	selected_unit.turn()

func _on_button_bury_unbury_pressed() -> void:
	if selected_unit:
		if selected_unit.buried: selected_unit.unbury()
		else: selected_unit.bury()
		enable_appropriate_actions()
		hide()

func _on_button_center_pressed() -> void:
	if selected_unit:
		for camera in get_tree().get_nodes_in_group("camera"):
			camera.move_to_transform(selected_unit.transform)
