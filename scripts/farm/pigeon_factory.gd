extends Node

@export var pigeon_scene: PackedScene
@export var pigeon_templates: Array[PigeonData]


func create_random() -> Pigeon:
	return create_from_template(
		pigeon_templates.pick_random()
	)


func create_from_template(template: PigeonData) -> Pigeon:
	var pigeon := pigeon_scene.instantiate() as Pigeon
	pigeon.data = template.duplicate(true)
	return pigeon


func create_egg(parent: PigeonData) -> EggData:
	var egg := parent.egg_template.duplicate(true)
	egg.parent_data = parent
	return egg


func create_from_egg(egg: EggData) -> Pigeon:
	var pigeon := pigeon_scene.instantiate() as Pigeon

	var data := egg.parent_data.duplicate(true)
	data.generation = egg.parent_data.generation + 1

	pigeon.data = data
	pigeon.data.egg_template.parent_data = pigeon.data

	return pigeon
