extends Button

export var silent := false

func _on_button_pressed() -> void:
	if not silent:
		$sfx_click.play()
