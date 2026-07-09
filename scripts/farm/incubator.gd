class_name Incubator
extends Node2D

signal egg_drag_requested(egg: Egg, slot: IncubatorSlot)
signal pigeon_drag_requested(pigeon: Pigeon, slot: IncubatorSlot)

@export var slot_scene: PackedScene
@export var slot_count := 4
@export var slot_interval := 210

var slots: Array[IncubatorSlot] = []


func _ready():
	_generate_slots()
	
	update_unlocked_slots()
	
	for slot in slots:
		slot.egg_drag_requested.connect(
			_on_slot_egg_drag_requested
		)
		
		slot.pigeon_drag_requested.connect(
			_on_slot_pigeon_drag_requested
		)

func _generate_slots():
	for i in slot_count:
		var slot := slot_scene.instantiate() as IncubatorSlot
		add_child(slot)
		slot.position = Vector2(i * slot_interval, -42)
		slots.append(slot)


func update_unlocked_slots():
	for i in slots.size():
		slots[i].visible = i < PlayerData.upgrades.unlocked_incubators


func add_egg(egg: Egg) -> bool:
	for i in PlayerData.upgrades.unlocked_incubators:
		var slot := slots[i]

		if slot.is_empty():
			slot.put_egg(egg)
			return true

	return false


func get_hovered_slot() -> IncubatorSlot:
	for i in PlayerData.upgrades.unlocked_incubators:
		var slot := slots[i]

		if slot.hovered:
			return slot

	return null


func _on_slot_egg_drag_requested(egg: Egg):
	var slot := egg.get_parent() as IncubatorSlot
	var taken := slot.take_egg()

	if taken:
		egg_drag_requested.emit(taken, slot)


func _on_slot_pigeon_drag_requested(pigeon: Pigeon):
	var slot := pigeon.get_parent() as IncubatorSlot
	
	if slot == null:
		return
	
	var taken := slot.take_pigeon()

	if taken:
		pigeon_drag_requested.emit(taken, slot)


func get_slots():
	return slots
