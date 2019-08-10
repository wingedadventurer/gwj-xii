extends Control
class_name class_unit_ui

onready var unit_name = $vb/p/vb/unit_name
onready var unit_profile = $vb/p/vb/unit_background/unit_profile
onready var button_move = $vb/p_2/vb/vb/button_move
onready var button_bury = $vb/p_2/vb/vb/button_bury
onready var button_unbury = $vb/p_2/vb/vb/button_unbury
onready var button_fire_signal = $vb/p_2/vb/vb/button_fire_signal

var unit_profiles := {
	UNIT_NONE: preload("res://textures/unit_profiles/profile_empty.png"),
	UNIT_CARROT: preload("res://textures/unit_profiles/profile_carrot.png"),
	UNIT_POTATO: preload("res://textures/unit_profiles/profile_potato.png"),
}

var unit_names := {
	UNIT_NONE: "None",
	UNIT_CARROT: "Carrot",
	UNIT_POTATO: "Potato",
}

const UNIT_NONE := 0
const UNIT_CARROT := 1
const UNIT_POTATO := 2

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
	button_move.disabled = true
	button_bury.disabled = true
	button_unbury.disabled = true
	button_fire_signal.disabled = true

func enable_appropriate_actions() -> void:
	disable_all_actions()
	if selected_unit:
		if selected_unit.buried: button_unbury.disabled = false
		else: button_bury.disabled = false

func _on_button_move_pressed() -> void:
	pass # Replace with function body.

func _on_button_bury_pressed() -> void:
	if selected_unit:
		selected_unit.bury()
		enable_appropriate_actions()

func _on_button_unbury_pressed() -> void:
	if selected_unit:
		selected_unit.unbury()
		enable_appropriate_actions()
