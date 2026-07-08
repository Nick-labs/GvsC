class_name WorldFarm
extends Node2D

signal destroyed
signal hp_changed(health)

@export var max_health := 100
@export var regen_amount := 1
@export var regen_interval := 10.0

var health := max_health
var regen_timer := 0.0


func _ready():
	health = max_health
	hp_changed.emit(health)


func _process(delta):
	if health <= 0:
		return

	regen_timer -= delta

	if regen_timer <= 0:
		regenerate()
		regen_timer = regen_interval


func regenerate():
	if health < max_health:
		health += regen_amount
		health = min(health,max_health)
		hp_changed.emit(health)


func take_damage(damage:float):
	health -= damage
	health = max(health,0)

	hp_changed.emit(health)

	if health <= 0:
		destroy()


func destroy():
	destroyed.emit()
