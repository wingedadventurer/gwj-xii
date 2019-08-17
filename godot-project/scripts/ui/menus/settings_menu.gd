extends Control

onready var option_shadows := $vbox/grid_container/option_shadows
onready var option_bloom := $vbox/grid_container/option_bloom
onready var option_ssao := $vbox/grid_container/option_ssao
onready var option_filtering := $vbox/grid_container/option_filtering
onready var option_msaa := $vbox/grid_container/option_msaa

func appear() -> void:
	visible = true

func disappear() -> void:
	visible = false

func _ready() -> void:
	for current in [option_bloom, option_ssao, option_msaa]:
		current.add_item("Off")
	for current in [option_shadows, option_bloom, option_ssao]:
		current.add_item("Low")
		current.add_item("Medium")
		current.add_item("High")
	for current in [option_filtering, option_msaa]:
		current.add_item("2x")
		current.add_item("4x")
		current.add_item("8x")
		current.add_item("16x")

func _on_option_shadows_item_selected(ID : int) -> void:
	settings.set_shadows(ID)

func _on_option_bloom_item_selected(ID : int) -> void:
	settings.set_bloom(ID)

func _on_option_ssao_item_selected(ID : int) -> void:
	settings.set_ssao(ID)

func _on_option_filtering_item_selected(ID : int) -> void:
	settings.set_filtering(ID)

func _on_option_msaa_item_selected(ID : int) -> void:
	settings.set_msaa(ID)

func _on_check_box_bloom_toggled(button_pressed : bool) -> void:
	settings.set_bloom(button_pressed)

func _on_check_box_fullscreen_toggled(button_pressed : bool) -> void:
	pass # Replace with function body.
