extends WorldEnvironment

func set_ssao(value : int) -> void:
	if value == 0:
		environment.ssao_enabled = false
	else:
		environment.ssao_enabled = true
		environment.ssao_quality = value + 1

func set_bloom(value : bool) -> void:
	environment.glow_enabled = value
