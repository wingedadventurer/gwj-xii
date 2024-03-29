extends Control

signal next_turn(me)

var scene_menu_path = "res://scenes/ui/menus/main_menu.tscn"
onready var harvest_days = $harvest_day/vb/days

var remaining_days := 5 setget set_remaining_days

var lose_reasons := {
	0: "Dread it. Run from it. Harvest day arrives all the same...\n\nAnd now it's here.",
	1: "I spy with my little eye something beginning with V!",
}

func _ready() -> void:
	$win_popup.hide()
	$lose_popup.hide()
	
	for level in get_tree().get_nodes_in_group("level"):
		if not level.next_level:
			$win_popup/vb/hb/button_next.visible = false

func set_remaining_days(value) -> void:
	# warning-ignore:narrowing_conversion
	remaining_days = ceil(value)
	
	if remaining_days == 0:
		harvest_days.text = "NOW"
	else:
		harvest_days.text = str(remaining_days)

func _on_button_next_turn_pressed() -> void:
	emit_signal("next_turn", self)

func _on_button_fire_signal_pressed() -> void:
	for signal_start in get_tree().get_nodes_in_group("signal_start"):
		signal_start.spawn_signal()
	$game_controls/vb/hb/button_fire_signal.disabled = true

func show_win_screen() -> void:
	$win_popup.show()
	$sfx_win.play()
	audio_manager.stop_ambience()
	AudioServer.set_bus_volume_db(1, -20)

func show_lose_screen(reason := -1) -> void:
	$lose_popup.show()
	if reason > -1:
		$lose_popup/vb_2/reason.text = lose_reasons[reason]
		match reason:
			0:
				$sfx_lose_harvest.play()
			1:
				$sfx_lose_farmer.play()
	audio_manager.stop_ambience()
	AudioServer.set_bus_volume_db(1, -20)

func disable_buttons() -> void:
	$game_controls/vb/hb/button_next_turn.disabled = true
	$game_controls/vb/hb/button_fire_signal.disabled = true
	for unit_icon in $unit_icons/vb/units.get_children():
		unit_icon.disabled = true
		unit_icon.modulate.a = 0.1

func enable_buttons() -> void:
	$game_controls/vb/hb/button_next_turn.disabled = false
	$game_controls/vb/hb/button_fire_signal.disabled = false
	for unit_icon in $unit_icons/vb/units.get_children():
		unit_icon.disabled = false
		unit_icon.modulate.a = 1.0

func set_days_to_harvest(value : int) -> void:
	var time := 1.0
	$harvest_days_tween.interpolate_method(self, "set_remaining_days", 100.0, float(value), time, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$harvest_days_tween.start()

func _on_harvest_days_tween_tween_completed(object, key):
	$harvest_days_scale_tween.interpolate_property(harvest_days, "rect_scale", Vector2.ONE * 1.3, Vector2.ONE * 1.0, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$harvest_days_scale_tween.start()
	$sfx_ding.play()

func _on_button_menu_pressed() -> void:
	AudioServer.set_bus_volume_db(1, 0)
	get_tree().change_scene(scene_menu_path)

func _on_button_next_pressed() -> void:
	AudioServer.set_bus_volume_db(1, 0)
	for level in get_tree().get_nodes_in_group("level"):
		if level.next_level:
			get_tree().change_scene_to(level.next_level)

func _on_button_retry_pressed() -> void:
	AudioServer.set_bus_volume_db(1, 0)
	get_tree().reload_current_scene()

func set_level_hint(text := "") -> void:
	if text == "": return
	$game_controls/vb/hb/help_button.disabled = false
	$level_text/text.text = text
	$game_controls/vb/hb/help_button/animation_player.play("flash")

func _on_help_button_pressed() -> void:
	$level_text.visible = !$level_text.visible
