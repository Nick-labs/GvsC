extends Node


var player := AudioStreamPlayer.new()


func _ready():
	add_child(player)


func play_music(stream: AudioStream):
	player.stream = stream
	player.play()
