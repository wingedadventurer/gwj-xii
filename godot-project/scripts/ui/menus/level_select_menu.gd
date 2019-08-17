extends Control

onready var grid_container := $grid_container
onready var tween := $tween

func appear() -> void:
	tween.interpolate_property(grid_container, "rect_position", Vector2(-1000, 127), Vector2(228, 127), 1.0, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	tween.start()
	yield(get_tree().create_timer(0.01), "timeout") # I know, I know
	visible = true

func disappear() -> void:
	tween.interpolate_property(grid_container, "rect_position", Vector2(228, 127), Vector2(-1000, 127), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_all_completed")
	visible = false
