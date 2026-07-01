class_name Cell
extends Node2D

@onready var marker: Marker2D = $Marker2D

var pigeon: Pigeon
var index: Vector2i


func set_pigeon(new_pigeon: Pigeon) -> void:
	pigeon = new_pigeon
	
	if pigeon == null:
		return
	
	add_child(pigeon)
	pigeon.position = marker.position


func remove_pigeon() -> Pigeon:
	var old := pigeon
	
	if pigeon:
		remove_child(pigeon)
	
	pigeon = null
	
	return old


func is_empty() -> bool:
	return pigeon == null

func _draw():
	draw_circle(Vector2.ZERO, 5, Color.RED)
