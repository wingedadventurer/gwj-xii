extends Spatial
class_name class_celery

signal caught_signal(me)

var caught := false

# warning-ignore:unused_class_variable
var unit_type := 4

func _on_signal_receive_area_body_entered(body) -> void:
	if not caught:
		if body is class_signal:
			body.die()
			caught = true
			$animation_player.play("unbury")
			$animation_player.queue("spin")
			$sfx_ding.play()
			emit_signal("caught_signal", self)

func reset() -> void:
	caught = false
	$animation_player.play("bury")
