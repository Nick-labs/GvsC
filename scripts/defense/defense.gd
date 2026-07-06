class_name Defense
extends Node2D

@export var fox_scene: PackedScene

@onready var world: Node2D = $World
@onready var base: WorldFarm = $World/Base
@onready var spawn_point: Marker2D = $SpawnPoint


func _ready() -> void:
	spawn_fox()
	

func spawn_fox():
	var fox := fox_scene.instantiate() as Fox
	add_child(fox)

	fox.global_position = spawn_point.global_position
	fox.target = base
