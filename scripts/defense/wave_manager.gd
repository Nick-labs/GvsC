class_name WaveManager
extends Node

signal wave_finished(wave:int)
signal all_waves_finished

@export var spawner:EnemySpawner
@export var max_waves := 5

var current_wave := 0
var enemies_left_to_spawn := 0
var alive_enemies := 0
var started := false

func _ready():
	spawner.enemy_spawned.connect(_on_enemy_spawned)
	spawner.enemy_died.connect(_on_enemy_died)

	TimeManager.hour_passed.connect(_on_hour_passed)

	if is_night():
		started = true
		start_next_wave()


func _on_hour_passed(_day,_hour):
	if is_night() and TimeManager.hour == 22:
		AudioManager.play_music_by_name("night")
	elif TimeManager.hour == 6:
		AudioManager.play_music_by_name("farm")
	
	if is_night() and not started:
		await UIManager.show_warning(
			"⚠ Чернобурки приближаются!",
			5.0
		)
		
		started = true
		
		start_next_wave()

	if not is_night():
		started = false


func start_next_wave():
	current_wave += 1

	if current_wave > max_waves:
		all_waves_finished.emit()
		return

	enemies_left_to_spawn = get_wave_size()

	spawn_wave()

func spawn_wave():

	while enemies_left_to_spawn > 0:

		if not is_night():
			return

		spawner.spawn_enemy()

		enemies_left_to_spawn -= 1

		await get_tree().create_timer(1).timeout

func get_wave_size()->int:
	return 5 + current_wave * 3

func _on_enemy_spawned(_enemy):
	alive_enemies += 1

func _on_enemy_died():

	alive_enemies -= 1

	if alive_enemies <= 0 and enemies_left_to_spawn <= 0:

		wave_finished.emit(current_wave)

func is_night()->bool:
	return TimeManager.hour >= 22 or TimeManager.hour < 6
