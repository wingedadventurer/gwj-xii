extends Control

func _on_button_next_turn_pressed() -> void:
	for unit in get_tree().get_nodes_in_group("unit"):
		unit.action_done = false
		unit.signals_launched = false
	for celery in get_tree().get_nodes_in_group("celery"):
		(celery as class_celery).reset()
	for level in get_tree().get_nodes_in_group("level"):
		(level as class_level).reset_remaining_celery_count()

func _on_button_fire_signal_pressed() -> void:
	for signal_start in get_tree().get_nodes_in_group("signal_start"):
		signal_start.spawn_signal()
