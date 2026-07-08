extends Node

@export var pigeon_scene: PackedScene
@export var start_pigeons: Array[PigeonData]


func create_start_pigeon() -> Pigeon:
	print(start_pigeons)
	return create_from_template(
		start_pigeons.pick_random()
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
	var template: PigeonData = SpeciesRegistry.get_random_hatchable_by_egg(egg)
	
	print("Template: ", template)
	
	var pigeon := pigeon_scene.instantiate() as Pigeon
	pigeon.data = template.duplicate(true)
	
	pigeon.data.generation = egg.parent_data.generation + 1
	
	return pigeon
