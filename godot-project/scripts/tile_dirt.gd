extends Spatial

var object = null
var has_object := false

func _ready() -> void:
	$highlight_mesh.material_override = $highlight_mesh.material_override.duplicate()

func _on_area_mouse_entered() -> void:
	$highlight_animation.play("tile_highlight")

func _on_area_mouse_exited() -> void:
	$highlight_animation.play("tile_unhighlight")
