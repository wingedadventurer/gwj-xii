extends TextureButton

signal level_selected(level)

export (PackedScene) var level

func _ready() -> void:
	if not level:
		disabled = true
		modulate.a = 0.5

func _on_level_button_pressed() -> void:
	emit_signal("level_selected", level)
