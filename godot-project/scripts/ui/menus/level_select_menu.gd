extends Control

onready var grid_container := $grid_container
onready var tween := $tween

var out_position = Vector2(-1000, 127)
var in_position = Vector2(320, 127)

func appear() -> void:
	tween.interpolate_property(grid_container, "rect_position", out_position, in_position, 0.8, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(0.01), "timeout") # I know, I know
	visible = true

func disappear() -> void:
	tween.interpolate_property(grid_container, "rect_position", in_position, out_position, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_all_completed")
	visible = false
