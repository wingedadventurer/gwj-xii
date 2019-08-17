extends Control

onready var animation_player := $animation_player

func appear() -> void:
	animation_player.play("appear")
	animation_player.seek(0.0, true)
	visible = true

func disappear() -> void:
	animation_player.play("disappear")
	yield(animation_player, "animation_finished")
	visible = false
