class_name Fox
extends CharacterBody2D

signal died

@export var speed := 80.0
@export var hp := 3

@export var attack_distance := 70.0
@export var attack_damage := 5
@export var attack_interval := 1.0

var attack_timer := 0.0

var target: Node2D = null


func _physics_process(delta):
	if target == null:
		return

	var distance := global_position.distance_to(
		target.global_position
	)

	if distance > attack_distance:
		move_to_target()
	else:
		attack(delta)


func move_to_target():
	var direction := (
		target.global_position - global_position
	).normalized()

	velocity = direction * speed
	move_and_slide()


func attack(delta):
	velocity = Vector2.ZERO

	attack_timer -= delta

	if attack_timer <= 0:
		target.take_damage(attack_damage)
		attack_timer = attack_interval


func take_damage(damage: int):
	hp -= damage

	if hp <= 0:
		die()


func die():
	died.emit()
	queue_free()
