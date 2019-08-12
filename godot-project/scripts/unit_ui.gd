extends Control
class_name class_unit_ui

onready var unit_name = $vb/p/vb/hb/unit_name
onready var unit_profile = $vb/p/vb/unit_background/unit_profile
onready var button_move = $vb/p_2/vb/vb/button_move
onready var button_bury = $vb/p_2/vb/vb/button_bury
onready var button_unbury = $vb/p_2/vb/vb/button_unbury

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
	button_move.disabled = true
	button_bury.disabled = true
	button_unbury.disabled = true

func enable_appropriate_actions() -> void:
	disable_all_actions()
	if selected_unit:
		# enable bury/unbury
		if selected_unit.buried: button_unbury.disabled = false
		else: button_bury.disabled = false
		
		# enable move
		if not selected_unit.buried:
			button_move.disabled = false

func _on_button_move_pressed() -> void:
	selected_unit.show_move_arrows()

func _on_button_bury_pressed() -> void:
	if selected_unit:
		selected_unit.bury()
		enable_appropriate_actions()
		hide()

func _on_button_unbury_pressed() -> void:
	if selected_unit:
		selected_unit.unbury()
		enable_appropriate_actions()
		hide()

func _on_button_close_pressed() -> void:
	if selected_unit:
		selected_unit.deselect()
	hide()
