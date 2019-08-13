extends CanvasLayer

onready var polygon := $polygon_2d
onready var tween := $tween

signal transition_done

func transition_done() -> void:
	emit_signal("transition_done")

func do_transition() -> void:
	tween.interpolate_property(polygon, "position", Vector2.ZERO, Vector2(2000.0, 0.0), 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.connect("tween_all_completed", self, "transition_done")
	tween.start()