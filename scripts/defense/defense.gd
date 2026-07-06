class_name Defense
extends Node2D

@export var fox_scene: PackedScene

@onready var world: Node2D = $World
@onready var base: WorldFarm = $World/Base
@onready var spawner: EnemySpawner = $EnemySpawner

func _ready() -> void:
	pass
