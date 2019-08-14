extends Control

func _on_left_mouse_entered() -> void:
	Input.action_press("camera_move_left")

func _on_right_mouse_entered() -> void:
	Input.action_press("camera_move_right")

func _on_up_mouse_entered() -> void:
	Input.action_press("camera_move_forward")

func _on_down_mouse_entered() -> void:
	Input.action_press("camera_move_back")

func _on_left_mouse_exited():
	Input.action_release("camera_move_left")

func _on_right_mouse_exited():
	Input.action_release("camera_move_right")

func _on_up_mouse_exited():
	Input.action_release("camera_move_forward")

func _on_down_mouse_exited():
	Input.action_release("camera_move_back")
