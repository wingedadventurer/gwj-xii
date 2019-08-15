extends Control

func appear() -> void:
	$animation_player.play("appear")
	visible = true

func disappear() -> void:
	visible = false
