extends Node

var ambience_audio = preload("res://audio/ambience/ambience.wav")

var music_audio = preload("res://audio/music/bama_country.ogg")

func play_ambience() -> void:
	$ambience.stream = ambience_audio
	$ambience.play()

func play_music() -> void:
	$music.stream = music_audio
	$music.play()

func stop_ambience() -> void:
	$ambience.stop()

func stop_music() -> void:
	$music.stop()
