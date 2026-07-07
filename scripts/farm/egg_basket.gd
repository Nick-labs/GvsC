class_name EggBasket
extends Node2D

@onready var storage_point: Marker2D = $Marker2D

var eggs: Array[Egg] = []
var reserved_slots := 0

@export var egg_spacing := 20.0
@export var max_in_row := 12


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
	var gp := egg.global_position

	egg.reparent(self)
	egg.global_position = gp

	eggs.append(egg)
	reserved_slots -= 1

	_layout()


func _layout():
	for i in eggs.size():
		var tween := create_tween()

		tween.tween_property(
			eggs[i],
			"position",
			_get_slot_position(i),
			0.1
		)


func _get_next_position() -> Vector2:
	var index := eggs.size() + reserved_slots

	reserved_slots += 1

	return _get_slot_global_position(index)


func _get_slot_position(index: int) -> Vector2:
	@warning_ignore("integer_division")
	var row := index / max_in_row
	var column := index % max_in_row

	return storage_point.position + Vector2(
		column * egg_spacing,
		-row * egg_spacing
	)


func _get_slot_global_position(index: int) -> Vector2:
	return to_global(_get_slot_position(index))
