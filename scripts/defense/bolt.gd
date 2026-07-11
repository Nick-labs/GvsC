class_name Bolt
extends Area2D

@export var speed := 900.0
@export var damage := 1.0

var direction := Vector2.ZERO
var traveled := 0.0
var max_distance := 2000.0


func _ready():
	rotation = direction.angle()


func _process(delta: float):
	var move := direction * speed * delta
	global_position += move

	traveled += move.length()

	if traveled > max_distance:
		queue_free()


func _on_body_entered(body):
	if body is Fox:
		body.take_damage(damage)
		queue_free()
