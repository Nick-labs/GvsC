class_name EggBasket
extends Node2D

signal egg_drag_requested(egg: Egg)

@export var egg_spacing := 20.0
@export var max_in_row := 12

var eggs: Array[Egg] = []
var reserved_slots := 0

var hovered := false

@onready var storage_point: Marker2D = $Marker2D


func _on_mouse_entered():
	hovered = true


func _on_mouse_exited():
	hovered = false


func is_empty() -> bool:
	return eggs.is_empty()


func get_egg_count() -> int:
	return eggs.size()


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


func add_egg_immediately(egg: Egg):
	egg.reparent(self)

	eggs.append(egg)

	egg.position = _get_slot_position(
		eggs.size() - 1
	)
	
	_update_z_order()
	_layout()


func _finish_receiving(egg: Egg):
	if !is_instance_valid(egg):
		reserved_slots -= 1
		return
	
	var gp := egg.global_position

	egg.reparent(self)
	egg.global_position = gp

	eggs.append(egg)
	reserved_slots -= 1

	_update_z_order()
	_layout()


func _update_z_order():
	for i in eggs.size():
		# тут был баг с freed object у яиц, пока так
		if eggs[i] != null:
			eggs[i].z_index = i


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


func take_egg(egg: Egg) -> int:
	if not eggs.has(egg):
		return -1

	var index := eggs.find(egg)

	var gp := egg.global_position

	eggs.erase(egg)

	egg.reparent(get_tree().current_scene)
	egg.global_position = gp

	_layout()

	return index


func return_egg(egg: Egg, index: int):
	egg.reparent(self)
	egg.position = _get_slot_position(index)

	eggs.append(egg)

	_update_z_order()
	_layout()


func _on_egg_drag_requested(egg: Egg):
	take_egg(egg)
	egg_drag_requested.emit(egg)
