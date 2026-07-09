class_name BackpackVisual
extends Node2D

@onready var marker: Marker2D = $Marker2D


func receive_egg(egg: Egg):
	var gp := marker.global_position

	egg.reparent(get_tree().current_scene)

	var tween := create_tween()

	tween.tween_property(
		egg,
		"global_position",
		gp,
		0.5
	)

	tween.finished.connect(
		_finish_receive_egg.bind(egg)
	)


func _finish_receive_egg(egg: Egg):
	if !is_instance_valid(egg):
		return

	if PlayerData.backpack.add_egg(egg.data):
		egg.queue_free()


func receive_pigeon(pigeon: Pigeon):
	var gp := marker.global_position

	pigeon.reparent(get_tree().current_scene)

	var tween := create_tween()

	tween.tween_property(
		pigeon,
		"global_position",
		gp,
		0.5
	)

	tween.finished.connect(
		_finish_receive_pigeon.bind(pigeon)
	)


func _finish_receive_pigeon(pigeon: Pigeon):
	if !is_instance_valid(pigeon):
		return
	
	if PlayerData.backpack.add_pigeon(pigeon.data):
		pigeon.queue_free()
	
