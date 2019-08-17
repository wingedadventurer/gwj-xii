extends Node

var ambience_audio = preload("res://audio/ambience/ambience.wav")

var music_title = preload("res://audio/music/whiskey-on-the-mississippi.ogg")
var music_ingame = preload("res://audio/music/bama_country.ogg")

enum TRACK {TITLE, INGAME}

func play_ambience() -> void:
	$ambience.stream = ambience_audio
	$ambience.play()

func play_music(which : int = TRACK.INGAME) -> void:
	if which == TRACK.INGAME:
		$music.stream = music_ingame
	else:
		$music.stream = music_title
	$music.play()

func stop_ambience() -> void:
	$ambience.stop()

func stop_music() -> void:
	$music.stop()
