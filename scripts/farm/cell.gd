class_name Cell
extends Node2D

@onready var marker: Marker2D = $Marker2D

var pigeon: Pigeon
var index: Vector2i

var hovered := false

@export var egg_scene: PackedScene
var eggs: Array[Egg] = []


func receive_egg(data: EggData) -> void:
	var egg := egg_scene.instantiate() as Egg
	add_child(egg)

	egg.position = marker.position + Vector2(randi_range(-10, 10), 60)
	egg.setup(data)

	eggs.append(egg)

#func spawn_egg_visual() -> void:
	#var egg = egg_scene.instantiate()
	#add_child(egg)
#
	#egg.position = marker.position + Vector2(0, 60)
#
#func collect_eggs() -> int:
	#var sum := 0
#
	#for e in eggs:
		#sum += e
#
	#eggs.clear()
#
	## убрать визуал тоже (если есть)
	#for child in get_children():
		#if child.name == "Egg":
			#child.queue_free()
#
	#return sum

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
	

func collect_eggs() -> int:
	var sum := 0

	for egg in eggs:
		sum += egg.value
		egg.queue_free()

	eggs.clear()

	return sum
