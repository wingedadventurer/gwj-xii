extends Node2D

signal transition_done

onready var polygon := $polygon_2d
onready var tween := $tween

var free_when_done := false

func transition_done() -> void:
	emit_signal("transition_done")
	if free_when_done:
		queue_free()

func do_transition() -> void:
	tween.interpolate_property(polygon, "position", Vector2.ZERO, Vector2.RIGHT * 2000.0, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.connect("tween_all_completed", self, "transition_done")
	tween.start()
