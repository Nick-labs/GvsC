class_name Defense
extends Node2D

signal farm_destroyed

signal farm_pressed
signal lose_game
signal win_game

@onready var base:WorldFarm = $World/Base
@onready var crossbow:Crossbow = $World/Base/Crossbow
@onready var wave_manager:WaveManager = $WaveManager
@onready var camera:Camera2D = $World/Camera2D
@onready var enemy_spawner := $EnemySpawner


@onready var base_hp_bar:ProgressBar = $CanvasLayer/BaseHPBar
@onready var win_screen:ColorRect = $CanvasLayer/WinScreen
@onready var lose_screen:ColorRect = $CanvasLayer/LoseScreen

@onready var base_destroyed := $BaseDestroyed


var active := true


func _ready():
	base.destroyed.connect(_on_base_destroyed)
	base.hp_changed.connect(_on_hp_changed)

	win_screen.hide()
	lose_screen.hide()

	base_hp_bar.max_value = base.max_health
	base_hp_bar.value = base.health


func _on_hp_changed(value):
	base_hp_bar.value = value


func _on_back_button_pressed():
	farm_pressed.emit()


func set_active(value:bool):
	active = value
	crossbow.can_shoot = value
	camera.enabled = value

	if value:
		camera.make_current()


func _on_base_destroyed():
	TimeManager.pause()
	
	enemy_spawner.remove_all_enemies()
	await base_destroyed.play()
	
	TimeManager.skip_hours(8)

	TimeManager.resume()

	base.health = base.max_health
	base.hp_changed.emit(base.health)
