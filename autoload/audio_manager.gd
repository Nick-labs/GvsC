extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sfx_root: Node = $SfxRoot

var music = {
	"intro": preload("res://assets/audio/music/maybe-storytale.ogg"),
	"day": preload("res://assets/audio/music/maybe-day.ogg"),
	"night": preload("res://assets/audio/music/maybe-night.ogg"),
	"farm": preload("res://assets/audio/music/farm.ogg"),
	"defeat": preload("res://assets/audio/music/defeat-maybe.ogg"),
}

var sounds = {
	"fox-attack": preload("res://assets/audio/sfx/fox-attack.ogg"),
	"shopkeeper": preload("res://assets/audio/sfx/voice.ogg"),
}


func _ready() -> void:
	pass
	#music_player.bus = "Music"
	

func play_music_by_name(name: String):
	if music.has(name):
		play_music(music[name])


func play_music(stream: AudioStream):
	if music_player.stream == stream and music_player.playing:
		return

	music_player.stream = stream
	music_player.play()


func stop_music():
	music_player.stop()


func play_sound(sound_name: String):
	if sounds.has(sound_name):
		play_sfx(sounds[sound_name])


func play_sfx(stream: AudioStream):
	var player := AudioStreamPlayer.new()
	
	#player.bus = "SFX"

	player.stream = stream

	sfx_root.add_child(player)

	player.finished.connect(
		player.queue_free
	)

	player.play()
