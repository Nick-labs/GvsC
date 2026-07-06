class_name EggBasket
extends Node2D

@onready var storage_point: Marker2D = $Marker2D

var eggs: Array[Egg] = []


func add_egg(egg: Egg):
	eggs.append(egg)
	add_child(egg)
	_layout_eggs()


func _layout_eggs():
	for i in eggs.size():
		eggs[i].position = storage_point.position + Vector2(
			i * 15,
			0
		)
