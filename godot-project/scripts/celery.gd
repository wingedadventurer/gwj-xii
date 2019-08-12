extends Spatial

func _on_signal_receive_area_body_entered(body) -> void:
		if body is class_signal:
			body.queue_free()
			print("Celery caught signal!")
