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

func display_unit(unit_type : int) -> void:
	show()
	unit_name.text = unit_names[unit_type]
	unit_profile.texture = unit_profiles[unit_type]

func _ready() -> void:
	disable_all()
	hide()

func disable_all() -> void:
	button_move.disabled = true
	button_bury.disabled = true
	button_unbury.disabled = true
	button_fire_signal.disabled = true
