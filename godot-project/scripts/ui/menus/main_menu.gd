extends Control

func _ready():
	connect_signals()
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
	$level_select_menu.appear()

func _on_settings_pressed() -> void:
	$title_menu.disappear()
	$settings_menu.appear()

func _on_credits_pressed() -> void:
	$title_menu.disappear()
	$credits_menu.appear()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_level_select_back_pressed() -> void:
	$level_select_menu.disappear()
	$title_menu.appear()

func _on_settings_back_pressed() -> void:
	$settings_menu.disappear()
	$title_menu.appear()

func _on_credits_back_pressed() -> void:
	$credits_menu.disappear()
	$title_menu.appear()

func _on_level_selected(level : PackedScene) -> void:
	if level:
		get_tree().change_scene_to(level)
