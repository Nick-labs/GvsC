class_name EggBasket
extends Node2D

@onready var storage_point: Marker2D = $Marker2D

var eggs: Array[Egg] = []
var reserved_slots := 0

const EGG_SPACING := 20.0
const MAX_IN_ROW := 11


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
		var row = i / MAX_IN_ROW
		var column = i % MAX_IN_ROW
		
		var tween := create_tween()

		tween.tween_property(
			eggs[i],
			"position",
			storage_point.position + \
				Vector2(
					column * EGG_SPACING,
					-row * EGG_SPACING
				),
			0.1
		)


func _get_next_position() -> Vector2:
	var index := eggs.size() + reserved_slots
	
	reserved_slots += 1
	
	@warning_ignore("integer_division")
	var row := index / MAX_IN_ROW
	var column := index % MAX_IN_ROW

	return storage_point.global_position + Vector2(
		column * EGG_SPACING,
		-row * EGG_SPACING
	)
