class_name EggBasket
extends Node2D

@onready var storage_point: Marker2D = $Marker2D

var eggs: Array[Egg] = []

const EGG_SPACING := 20.0
const MAX_IN_ROW := 11


func add_egg(egg: Egg):
	egg.reparent(self)
	egg.position = to_local(
		get_next_position()
	)
	eggs.append(egg)


func get_next_position() -> Vector2:
	var index := eggs.size()

	var row := index / MAX_IN_ROW
	var column := index % MAX_IN_ROW

	return storage_point.global_position + Vector2(
		column * EGG_SPACING,
		-row * EGG_SPACING
	)


func _layout_eggs():
	for i in eggs.size():
		eggs[i].position = storage_point.position + Vector2(
			i * 15,
			0
		)
