class_name Incubator
extends Node2D

signal egg_drag_requested(egg: Egg, slot: IncubatorSlot)

@export var slot_scene: PackedScene
@export var slot_count := 1

var slots: Array[IncubatorSlot] = []


func _ready():
	_generate_slots()
	
	for slot in slots:
		slot.egg_drag_requested.connect(
			_on_slot_egg_drag_requested
		)
		

func _generate_slots():
	for i in slot_count:
		var slot := slot_scene.instantiate() as IncubatorSlot
		add_child(slot)
		slot.position = Vector2(i * 120, 0)
		slots.append(slot)


func add_egg(egg: Egg) -> bool:
	for slot in slots:
		if slot.is_empty():
			slot.put_egg(egg)
			return true

	return false


func get_hovered_slot() -> IncubatorSlot:
	for slot in slots:
		if slot.hovered:
			return slot

	return null


func _on_slot_egg_drag_requested(egg: Egg):
	var slot := egg.get_parent() as IncubatorSlot
	var taken := slot.take_egg()

	if taken:
		egg_drag_requested.emit(taken, slot)
