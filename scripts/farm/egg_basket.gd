class_name EggBasket
extends Node2D

@onready var storage_point: Marker2D = $Marker2D

var eggs: Array[Egg] = []
var reserved_slots := 0

@export var egg_spacing := 20.0
@export var max_in_row := 11


func receive_egg(egg: Egg):
	var target := _get_next_position()

	egg.reparent(get_tree().current_scene)

	var tween := create_tween()

	tween.tween_property(
		egg,
		"global_position",
		target,
		1
	)

	tween.finished.connect(
		_finish_receiving.bind(egg)
	)


func _finish_receiving(egg: Egg):
	egg.reparent(self)
	eggs.append(egg)
	reserved_slots -= 1
	_layout()


func _layout():
	for i in eggs.size():
		@warning_ignore("integer_division")
		var row = i / max_in_row
		var column = i % max_in_row
		
		var tween := create_tween()

		tween.tween_property(
			eggs[i],
			"position",
			storage_point.position + \
				Vector2(
					column * egg_spacing,
					-row * egg_spacing
				),
			0.1
		)


func _get_next_position() -> Vector2:
	var index := eggs.size() + reserved_slots
	
	reserved_slots += 1
	
	@warning_ignore("integer_division")
	var row := index / max_in_row
	var column := index % max_in_row

	return storage_point.global_position + Vector2(
		column * egg_spacing,
		-row * egg_spacing
	)
