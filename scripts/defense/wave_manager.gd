class_name WaveManager
extends Node

signal wave_finished(wave: int)

@export var spawner: EnemySpawner

@export var time_between_waves := 10.0

var current_wave := 0

var enemies_left_to_spawn := 0
var alive_enemies := 0


func _ready():
	spawner.enemy_spawned.connect(_on_enemy_spawned)
	spawner.enemy_died.connect(_on_enemy_died)
	
	start_next_wave()


func start_loop():
	while true:
		await get_tree().create_timer(
			time_between_waves
		).timeout
		
		start_next_wave()


func start_next_wave():
	current_wave += 1
	enemies_left_to_spawn = get_wave_size()
	spawn_wave()


func spawn_wave():
	while enemies_left_to_spawn > 0:
		spawner.spawn_enemy()
		enemies_left_to_spawn -= 1
		
		await get_tree().create_timer(1.0).timeout


func get_wave_size() -> int:
	return 5 + current_wave * 3


func finish_wave() -> void:
	print("Волна %d завершена!" % current_wave)

	wave_finished.emit(current_wave)

	await get_tree().create_timer(time_between_waves).timeout

	start_next_wave()


func _on_enemy_spawned(_enemy: Fox):
	alive_enemies += 1


func _on_enemy_died():
	alive_enemies -= 1

	if alive_enemies == 0 and enemies_left_to_spawn == 0:
		finish_wave()
