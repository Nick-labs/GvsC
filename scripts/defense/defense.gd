class_name Defense
extends Node2D

@export var fox_scene: PackedScene

@onready var world: Node2D = $World
@onready var base: WorldFarm = $World/Base
@onready var spawner: EnemySpawner = $EnemySpawner

func _ready() -> void:
	pass


func _on_back_button_pressed() -> void:
	SceneManager.change_scene("farm")
