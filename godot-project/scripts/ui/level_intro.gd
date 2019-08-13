extends Control

onready var label_title := $label_title
onready var label_subtitle := $label_subtitle
onready var anim_player := $animation_player

func set_intro_text(title : String, subtitle : String) -> void:
	label_title.text = title
	label_subtitle.text = subtitle

func do_intro() -> void:
	anim_player.play("intro")
	anim_player.connect("animation_finished", self, "queue_free")
