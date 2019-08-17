extends Control

onready var option_shadows := $vbox/grid_container/option_shadows
onready var option_ssao := $vbox/grid_container/option_ssao
onready var option_msaa := $vbox/grid_container/option_msaa
onready var checkbox_bloom := $vbox/hbox/check_box_bloom
onready var checkbox_fullscreen := $vbox/hbox/check_box_fullscreen

func appear() -> void:
	visible = true

func disappear() -> void:
	visible = false

func _on_option_shadows_item_selected(ID : int) -> void:
	settings.set_shadows(ID)

func _on_option_ssao_item_selected(ID : int) -> void:
	settings.set_ssao(ID)

func _on_option_msaa_item_selected(ID : int) -> void:
	settings.set_msaa(ID)

func _on_check_box_bloom_toggled(button_pressed : bool) -> void:
	settings.set_bloom(button_pressed)

func _on_check_box_fullscreen_toggled(button_pressed : bool) -> void:
	settings.set_fullscreen(button_pressed)

func _ready() -> void:
	for current in [option_ssao, option_msaa]:
		current.add_item("Off")
	for current in [option_shadows, option_ssao]:
		current.add_item("Low")
		current.add_item("Medium")
		current.add_item("High")
	for current in [option_msaa]:
		current.add_item("2x")
		current.add_item("4x")
		current.add_item("8x")
		current.add_item("16x")
	# Now set the values to their current... well, value
	option_shadows.selected = settings.shadows
	option_ssao.selected = settings.ssao
	option_msaa.selected = settings.msaa
	checkbox_bloom.pressed = settings.bloom
	checkbox_fullscreen.pressed = settings.fullscreen
