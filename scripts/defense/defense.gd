class_name Defense
extends Node2D

signal farm_pressed

@export var fox_scene: PackedScene

@onready var world: Node2D = $World
@onready var base: WorldFarm = $World/Base
@onready var crossbow: Crossbow = $World/Base/Crossbow
@onready var spawner: EnemySpawner = $EnemySpawner
@onready var camera: Camera2D = $World/Camera2D

var active := true


func _ready() -> void:
	pass


func _on_back_button_pressed() -> void:
	farm_pressed.emit()


func set_active(value: bool):
	active = value
	crossbow.can_shoot = value
	
	if value:
		camera.enabled = true
		camera.make_current()
	else:
		camera.enabled = false
