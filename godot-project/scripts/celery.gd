extends Spatial

# warning-ignore:unused_class_variable
var unit_type := 4

func _on_signal_receive_area_body_entered(body) -> void:
		if body is class_signal:
			body.queue_free()
			print("Celery caught signal!")
