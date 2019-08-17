extends Control

const OBJ_TRANSITION_IN = preload("res://scenes/ui/transition_in.tscn")
const OBJ_TRANSITION_OUT = preload("res://scenes/ui/transition_out.tscn")

onready var demo = $demo

func _ready():
	connect_signals()
	do_transition_in()
	
func do_transition_in() -> void:
	var transition = OBJ_TRANSITION_IN.instance()
	add_child(transition)
	transition.free_when_done = true
	transition.connect("transition_done", self, "_on_transition_in_done")
	yield(get_tree().create_timer(0.5), "timeout")
	transition.do_transition()
	$title_menu.appear()

func connect_signals() -> void:
	# title menu
	$title_menu/buttons/button_play.connect("pressed", self, "_on_play_pressed")
	$title_menu/buttons/button_settings.connect("pressed", self, "_on_settings_pressed")
	$title_menu/buttons/button_credits.connect("pressed", self, "_on_credits_pressed")
	$title_menu/buttons/button_quit.connect("pressed", self, "_on_quit_pressed")
	# back buttons
	$level_select_menu/button_back.connect("pressed", self, "_on_level_select_back_pressed")
	$settings_menu/button_back.connect("pressed", self, "_on_settings_back_pressed")
	$credits_menu/button_back.connect("pressed", self, "_on_credits_back_pressed")
	# levels
	for level_button in $level_select_menu/grid_container.get_children():
		level_button.connect("level_selected", self, "_on_level_selected")

func _on_play_pressed() -> void:
	$title_menu.disappear()
	yield(get_tree().create_timer(0.4), "timeout")
	$level_select_menu.appear()

func _on_settings_pressed() -> void:
	$title_menu.disappear()
	demo.move_camera(2)
	yield(get_tree().create_timer(0.4), "timeout")
	$settings_menu.appear()

func _on_credits_pressed() -> void:
	$title_menu.disappear()
	yield(get_tree().create_timer(0.4), "timeout")
	$credits_menu.appear()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_level_select_back_pressed() -> void:
	$level_select_menu.disappear()
	yield(get_tree().create_timer(0.4), "timeout")
	$title_menu.appear()

func _on_settings_back_pressed() -> void:
	$settings_menu.disappear()
	demo.move_camera(1)
	$title_menu.appear()

func _on_credits_back_pressed() -> void:
	$credits_menu.disappear()
	$title_menu.appear()

func _on_level_selected(level : PackedScene) -> void:
	if level:
		var transition = OBJ_TRANSITION_OUT.instance()
		add_child(transition)
		transition.do_transition()
		yield(transition, "transition_done")
		get_tree().change_scene_to(level)
