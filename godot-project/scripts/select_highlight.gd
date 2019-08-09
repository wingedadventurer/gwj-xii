extends MeshInstance

var rotation_speed = 45.0

var rotate := false setget set_rotate

func set_rotate(value : bool) -> void:
	rotate = value
	
	if value == false:
		rotation.y = 0.0

func _process(delta : float) -> void:
	if rotate:
		rotation_degrees.y += rotation_speed * delta
