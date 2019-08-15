extends RigidBody
class_name class_signal

func _process(delta : float) -> void:
	# rotate projectile in movement direction
	pass
	
	# check if under certain height
	if global_transform.origin.y <= -1.0:
		queue_free()
