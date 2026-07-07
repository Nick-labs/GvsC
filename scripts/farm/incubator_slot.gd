class_name IncubatorSlot
extends Area2D

var egg: Egg = null
var pigeon: Pigeon = null

@onready var content: Node2D

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


func put_egg(new_egg: Egg):
	if not is_empty():
		return

	egg = new_egg

	new_egg.reparent(content)
	new_egg.position = Vector2.ZERO


#func take_pigeon() -> Pigeon:
	#pass
