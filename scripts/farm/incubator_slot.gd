class_name IncubatorSlot
extends Area2D

signal egg_drag_requested(egg: Egg)
signal pigeon_drag_requested(pigeon: Pigeon)

var egg: Egg = null
var minutes_until_hatch := 0

var pigeon: Pigeon = null

@onready var marker: Marker2D = $Marker2D

var hovered := false


func _on_minute_passed(_day: int, _hour: int, _minute: int):
	if egg == null:
		return

	minutes_until_hatch -= 1

	if minutes_until_hatch <= 0:
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
	minutes_until_hatch = 0

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
	minutes_until_hatch = egg.data.hatch_time_minutes


func put_pigeon(new_pigeon: Pigeon):
	if not is_empty():
		return

	pigeon = new_pigeon
	
	if pigeon.get_parent():
		pigeon.reparent(self)
	else:
		add_child(pigeon)
	
	pigeon.position = marker.position


func take_egg() -> Egg:
	if egg == null:
		return null

	var result := egg

	egg = null
	minutes_until_hatch = 0

	result.reparent(get_tree().current_scene)

	return result


func take_pigeon() -> Pigeon:
	if pigeon == null:
		return null

	var result := pigeon
	pigeon = null

	result.reparent(get_tree().current_scene)
	
	return result


func clear() -> void:
	if egg:
		egg.queue_free()
		egg = null
	
	if pigeon:
		pigeon.queue_free()
		pigeon = null

	minutes_until_hatch = 0


func _enter_tree():
	if !TimeManager.minute_passed.is_connected(_on_minute_passed):
		TimeManager.minute_passed.connect(_on_minute_passed)


func _exit_tree():
	if TimeManager.minute_passed.is_connected(_on_minute_passed):
		TimeManager.minute_passed.disconnect(_on_minute_passed)
