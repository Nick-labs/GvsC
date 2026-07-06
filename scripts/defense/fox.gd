class_name Fox
extends CharacterBody2D

@export var speed := 80.0
@export var hp := 3

var target: Node2D = null


func _physics_process(delta):
	if target == null:
		return

	var direction := (target.global_position - global_position).normalized()

	velocity = direction * speed
	move_and_slide()


func take_damage(damage: int):
	hp -= damage

	if hp <= 0:
		die()


func die():
	queue_free()
