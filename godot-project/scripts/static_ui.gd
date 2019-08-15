extends Control

signal next_turn(me)

onready var harvest_days = $harvest_day/vb/days

var remaining_days := 5 setget set_remaining_days

func _ready() -> void:
	$win_popup.hide()
	$lose_popup.hide()

func set_remaining_days(value) -> void:
	remaining_days = ceil(value)
	
	if remaining_days == 0:
		harvest_days.text = "NOW"
	else:
		harvest_days.text = str(remaining_days)

func _on_button_next_turn_pressed() -> void:
	for unit in get_tree().get_nodes_in_group("unit"):
		unit.action_done = false
		unit.signals_launched = false
	for celery in get_tree().get_nodes_in_group("celery"):
		(celery as class_celery).reset()
	for level in get_tree().get_nodes_in_group("level"):
		(level as class_level).reset_remaining_celery_count()
	emit_signal("next_turn", self)

func _on_button_fire_signal_pressed() -> void:
	for signal_start in get_tree().get_nodes_in_group("signal_start"):
		signal_start.spawn_signal()

func show_win_screen() -> void:
	$win_popup.show()

func show_lose_screen() -> void:
	$lose_popup.show()

func set_days_to_harvest(value : int) -> void:
	var time := 1.0
	$harvest_days_tween.interpolate_method(self, "set_remaining_days", 30.0, float(value), time, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$harvest_days_tween.start()

func _on_harvest_days_tween_tween_completed(object, key):
	$harvest_days_scale_tween.interpolate_property(harvest_days, "rect_scale", Vector2.ONE * 1.3, Vector2.ONE * 1.0, 1.0, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$harvest_days_scale_tween.start()
	$sfx_ding.play()

func _on_button_menu_pressed() -> void:
	pass

func _on_button_next_pressed() -> void:
	pass

func _on_button_retry_pressed() -> void:
	pass
