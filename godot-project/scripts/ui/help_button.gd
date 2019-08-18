extends "res://scripts/ui/button.gd"

func _on_button_pressed() -> void:
	._on_button_pressed()
	$animation_player.stop()
	modulate = Color(1, 1, 1)
