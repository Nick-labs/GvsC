class_name Incubator
extends Node2D

@export var slot_scene: PackedScene
@export var slot_count := 1

var slots: Array[IncubatorSlot] = []


func _ready():
	_generate_slots()


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
