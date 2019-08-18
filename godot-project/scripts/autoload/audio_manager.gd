extends Node

var ambience_audio = preload("res://audio/ambience/ambience.wav")

var music := {
	0: preload("res://audio/music/whiskey-on-the-mississippi.ogg"),
	1: preload("res://audio/music/bama_country.ogg"),
	2: preload("res://audio/music/neo-western.ogg"),
}


enum TRACK {TITLE, INGAME}

func play_ambience() -> void:
	$ambience.stream = ambience_audio
	$ambience.play()

func play_music(which : int = TRACK.INGAME) -> void:
	if $music.stream != music[which]:
		$music.stream = music[which]
		$music.play()

func stop_ambience() -> void:
	$ambience.stop()

func stop_music() -> void:
	$music.stop()
