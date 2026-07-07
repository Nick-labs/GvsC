class_name Crossbow
extends Node2D

@export var center: Node2D
@export var radius := 60
@export var rotation_speed := 8.0

@export var bolt_scene: PackedScene
@export var fire_rate := 0.4

var cooldown := 1.0
var can_shoot := true


func _process(delta):
	if center == null:
		return

	_update_rotation()

	_handle_shoot(delta)


func _update_rotation():
	var mouse_pos := get_global_mouse_position()
	var direction := mouse_pos - center.global_position
	var target_angle := direction.angle()

	rotation = lerp_angle(rotation, target_angle, 10.0 * get_process_delta_time())

	global_position = center.global_position + Vector2.RIGHT.rotated(rotation) * radius


func _handle_shoot(delta):
	cooldown -= delta

	if Input.is_action_pressed("shoot") and cooldown <= 0:
		shoot()
		cooldown = fire_rate


func shoot():
	var bolt := bolt_scene.instantiate() as Bolt
	
	bolt.global_position = global_position
	bolt.direction = Vector2.RIGHT.rotated(rotation)

	get_tree().current_scene.add_child(bolt)
