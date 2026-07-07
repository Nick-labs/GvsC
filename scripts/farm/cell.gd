class_name Cell
extends Node2D

@export var egg_scene: PackedScene

var pigeon: Pigeon
var index: Vector2i
var hovered := false
var eggs: Array[Egg] = []

@onready var marker: Marker2D = $Marker2D


func set_pigeon(new_pigeon: Pigeon) -> void:
	if new_pigeon == null:
		return

	pigeon = new_pigeon
	pigeon.cell = self
	
	if pigeon.get_parent(): 
		new_pigeon.reparent(self)
	else:
		add_child(new_pigeon)
	
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


func receive_egg(data: EggData) -> void:
	var egg := egg_scene.instantiate() as Egg
	add_child(egg)

	egg.position = marker.position + Vector2(randi_range(-10, 10), 60)
	egg.setup(data)

	eggs.append(egg)


func take_eggs() -> Array[Egg]:
	var result := eggs.duplicate()
	eggs.clear()
	return result


func _on_mouse_entered():
	hovered = true


func _on_mouse_exited():
	hovered = false
