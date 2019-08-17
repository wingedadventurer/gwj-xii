extends CanvasLayer

const OBJ_TRANSITION_OUT = preload("res://scenes/ui/transition_out.tscn")

func _ready():
	get_tree().paused = true

func _on_button_resume_pressed():
	get_tree().paused = false
	queue_free()

func _on_button_restart_pressed():
	var transition = OBJ_TRANSITION_OUT.instance()
	add_child(transition)
	transition.do_transition()
	yield(transition, "transition_done")
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_button_back_to_menu_pressed():
	audio_manager.stop_ambience()
	audio_manager.stop_music()
	var transition = OBJ_TRANSITION_OUT.instance()
	add_child(transition)
	transition.do_transition()
	yield(transition, "transition_done")
	get_tree().paused = false
	get_tree().change_scene("res://scenes/ui/menus/main_menu.tscn")
