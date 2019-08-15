extends RigidBody
class_name class_signal

func _process(delta : float) -> void:
	# rotate projectile in movement direction
	pass
	
	# check if under certain height
	if global_transform.origin.y <= -1.0:
		die()

func die() -> void:
	mode = RigidBody.MODE_STATIC
	$particles_local.visible = false
	$collision_shape.disabled = true
	$omni_light.visible = false
	$death_timer.start(1.0)
	$particles_trail.emitting = false

func _on_death_timer_timeout() -> void:
	queue_free()
