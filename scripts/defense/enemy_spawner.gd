class_name EnemySpawner
extends Node


@export var enemy_scene: PackedScene

@export var base: Node2D
@export var enemy_container: Node2D

@export var spawn_radius := 1000.0
@export var spawn_interval := 3.0


func _ready():
	start_spawning()


func start_spawning():
	while true:
		spawn_enemy()

		await get_tree().create_timer(
			spawn_interval
		).timeout


func spawn_enemy():
	var enemy := enemy_scene.instantiate() as Fox
	
	enemy_container.add_child(enemy)

	enemy.global_position = get_spawn_position()
	enemy.target = base


func get_spawn_position() -> Vector2:
	var angle := randf() * TAU
	
	return base.global_position + Vector2(
		cos(angle),
		sin(angle)
	) * spawn_radius
