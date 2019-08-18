extends Node

onready var shadows := 2
onready var ssao := 0
onready var msaa := 0
onready var bloom := true
onready var fullscreen := false

func set_shadows(value : int) -> void:
	shadows = value
	ProjectSettings.set_setting("rendering/quality/shadows/filter_mode", shadows)

func set_bloom(value : bool) -> void:
	bloom = value
	get_tree().call_group("environment", "set_bloom", bloom)

func set_ssao(value : int) -> void:
	ssao = value
	get_tree().call_group("environment", "set_ssao", ssao)

func set_msaa(value : int) -> void:
	msaa = value
	ProjectSettings.set_setting("rendering/quality/filters/msaa", msaa)
	get_viewport().msaa = msaa

func set_fullscreen(value: bool) -> void:
	fullscreen = value
	OS.window_fullscreen = fullscreen

func apply_settings() -> void:
	ProjectSettings.set_setting("rendering/quality/shadows/filter_mode", shadows)
	get_tree().call_group("environment", "set_bloom", bloom)
	get_tree().call_group("environment", "set_ssao", ssao)
	ProjectSettings.set_setting("rendering/quality/filters/msaa", msaa)
	get_viewport().msaa = msaa
	OS.window_fullscreen = fullscreen

func _ready() -> void:
	apply_settings()