class_name IncubatorSlot
extends Area2D

signal egg_drag_requested(egg: Egg)
signal pigeon_drag_requested(pigeon: Pigeon)

var egg: Egg = null
var hatch_timer := 0.0

var pigeon: Pigeon = null

@onready var marker: Marker2D = $Marker2D

var hovered := false


func _process(delta):
	if egg == null:
		return

	hatch_timer += delta

	if hatch_timer >= egg.data.hatch_time:
		hatch()


func _on_input_event(
	_viewport: Node,
	event: InputEvent,
	_shape_idx: int
):

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_RIGHT \
	and event.pressed:

		if pigeon:
			pigeon_drag_requested.emit(pigeon)

		elif egg:
			egg_drag_requested.emit(egg)


func hatch():
	if egg == null:
		return

	var egg_data := egg.data

	egg.queue_free()
	egg = null

	var new_pigeon: Pigeon = PigeonFactory.create_from_egg(egg_data)

	put_pigeon(new_pigeon)


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
	hatch_timer = 0.0


func put_pigeon(new_pigeon: Pigeon):
	if not is_empty():
		return

	print("back")

	pigeon = new_pigeon
	
	if pigeon.get_parent():
		pigeon.reparent(self)
	else:
		add_child(pigeon)
	
	pigeon.position = marker.position - Vector2(0, 60)


func take_egg() -> Egg:
	if egg == null:
		return null

	var result := egg

	egg = null

	result.reparent(get_tree().current_scene)

	return result


func take_pigeon() -> Pigeon:
	if pigeon == null:
		return null

	var result := pigeon
	pigeon = null

	result.reparent(get_tree().current_scene)

	return result
