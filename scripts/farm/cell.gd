class_name Cell
extends Node2D

@onready var marker: Marker2D = $Marker2D

var pigeon: Pigeon
var index: Vector2i

var hovered := false

func _on_mouse_entered():
	hovered = true

func _on_mouse_exited():
	hovered = false

func set_pigeon(new_pigeon: Pigeon) -> void:
	if new_pigeon == null:
		return

	if new_pigeon.get_parent():
		new_pigeon.get_parent().remove_child(new_pigeon)

	pigeon = new_pigeon
	pigeon.cell = self

	add_child(pigeon)
	pigeon.position = marker.position

func remove_pigeon() -> void:
	if pigeon == null:
		return

	pigeon.queue_free()
	pigeon = null


func take_pigeon() -> Pigeon:
	var result := pigeon

	if result != null:
		result.cell = null

	pigeon = null

	return result


func is_empty() -> bool:
	return pigeon == null
	

#func _draw():
	#draw_circle(Vector2.ZERO, 5, Color.RED)
