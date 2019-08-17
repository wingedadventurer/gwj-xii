extends Node

var shadows : int
var ssao : int
var filtering : int
var msaa : int
var bloom : bool
var fullscreen : bool

func set_shadows(value : int) -> void:
	shadows = value
	ProjectSettings.set_setting("rendering/quality/shadows/filter_mode", shadows)

func set_bloom(value : bool) -> void:
	bloom = value
	get_tree().call_group("environment", "set_bloom", value)

func set_ssao(value : int) -> void:
	ssao = value
	get_tree().call_group("environment", "set_ssao", value)

func set_filtering(value : int) -> void:
	filtering = value
	ProjectSettings.set_setting("rendering/quality/filters/anisotropic_filter_level", value)

func set_msaa(value : int) -> void:
	msaa = value
	get_viewport().msaa = value
	ProjectSettings.set_setting("rendering/quality/filters/msaa", value)
	
