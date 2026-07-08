extends Node

@onready var player: AudioStreamPlayer2D = $AudioStreamPlayer2D


func play_music(stream: AudioStream):
	if player.stream == stream and player.playing:
		return

	player.stream = stream
	player.play()


func stop_music():
	player.stop()
