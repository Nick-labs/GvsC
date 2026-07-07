class_name IncubatorSlot
extends Area2D

signal egg_drag_requested(egg: Egg)

var egg: Egg = null
var pigeon: Pigeon = null

@onready var marker: Marker2D = $Marker2D

var hovered := false


func _on_mouse_entered():
	hovered = true


func _on_mouse_exited():
	hovered = false


func is_empty() -> bool:
	return egg == null and pigeon == null


func has_egg() -> bool:
	return egg != null


func has_pigeon() -> bool:
	return pigeon != null


func put_item(item):
	if item is Egg:
		put_egg(item)

	elif item is Pigeon:
		put_pigeon(item)


func put_egg(new_egg: Egg):
	if not is_empty():
		return

	new_egg.reparent(self)
	new_egg.position = marker.position

	egg = new_egg


func put_pigeon(new_pigeon: Pigeon):
	pass


func take_egg() -> Egg:
	if egg == null:
		return null

	var result := egg

	egg = null

	result.reparent(get_tree().current_scene)

	return result


#func take_pigeon() -> Pigeon:
	#pass


func _on_input_event(
	_viewport: Node,
	event: InputEvent,
	_shape_idx: int
):

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_RIGHT \
	and event.pressed:

		if egg:
			egg_drag_requested.emit(egg)
