class_name Crossbow
extends Node2D

@export var center: Node2D
@export var radius := 40
@export var rotation_speed := 8.0

func _process(delta):
	if center == null:
		return

	var mouse_pos := get_global_mouse_position()

	# направление от центра к мыши
	var direction := mouse_pos - center.global_position

	# угол
	var target_angle := direction.angle()

	# плавное вращение
	rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

	# позиция вокруг базы
	global_position = center.global_position + Vector2.RIGHT.rotated(rotation) * radius
