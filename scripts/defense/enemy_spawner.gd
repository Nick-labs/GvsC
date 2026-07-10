class_name EnemySpawner
extends Node

signal enemy_spawned(enemy:Fox)
signal enemy_died

@export var enemy_scene:PackedScene
@export var base:Node2D
@export var enemy_container:Node2D

@export var spawn_radius := 1000.0


func spawn_enemy():

	if not is_night():
		return
	
	var enemy = enemy_scene.instantiate() as Fox
	
	enemy_container.add_child(enemy)
	
	enemy.global_position = _get_spawn_position()
	enemy.target = base
	
	enemy.died.connect(_on_enemy_died)
	
	enemy_spawned.emit(enemy)


func _get_spawn_position() -> Vector2:
	var angle = randf() * TAU

	return base.global_position + Vector2(
		cos(angle),
		sin(angle)
	) * spawn_radius


func _on_enemy_died():
	enemy_died.emit()


func is_night() -> bool:
	return TimeManager.hour >= 22 or TimeManager.hour < 6
