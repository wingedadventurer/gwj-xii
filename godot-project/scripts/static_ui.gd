extends Control

func _on_button_next_turn_pressed() -> void:
	for unit in get_tree().get_nodes_in_group("unit"):
		unit.action_done = false
