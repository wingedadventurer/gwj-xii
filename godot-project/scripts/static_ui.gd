extends Control

signal next_turn(me)

func _ready() -> void:
	$win_popup.hide()
	$lose_popup.hide()

func _on_button_next_turn_pressed() -> void:
	for unit in get_tree().get_nodes_in_group("unit"):
		unit.action_done = false
		unit.signals_launched = false
	for celery in get_tree().get_nodes_in_group("celery"):
		(celery as class_celery).reset()
	for level in get_tree().get_nodes_in_group("level"):
		(level as class_level).reset_remaining_celery_count()
	emit_signal("next_turn", self)

func _on_button_fire_signal_pressed() -> void:
	for signal_start in get_tree().get_nodes_in_group("signal_start"):
		signal_start.spawn_signal()

func show_win_screen() -> void:
	$win_popup.show()

func show_lose_screen() -> void:
	$lose_popup.show()

func set_last_day() -> void:
	$hb/button_next_turn.text = "Ur dead :("

func set_days_to_harvest(value : int) -> void:
	$harvest_days_label.text = "Days to harvest\n" + str(value)

func _on_button_menu_pressed() -> void:
	pass

func _on_button_next_pressed() -> void:
	pass

func _on_button_retry_pressed() -> void:
	pass
