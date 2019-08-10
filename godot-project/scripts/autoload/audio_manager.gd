extends Node

var ambience_audio = preload("res://audio/ambience/ambience.wav")

func _ready() -> void:
	play_ambience()

func play_ambience() -> void:
	$ambience.stream = ambience_audio
	$ambience.play()
