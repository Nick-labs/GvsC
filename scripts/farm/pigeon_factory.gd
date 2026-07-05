extends Node

@export var pigeon_scene: PackedScene
@export var pigeon_datas: Array[PigeonData]


func create_random() -> Pigeon:
	return create_from_template(
		pigeon_datas.pick_random()
	)


func create_from_template(template: PigeonData) -> Pigeon:
	var pigeon := pigeon_scene.instantiate() as Pigeon
	pigeon.data = template.duplicate(true)
	return pigeon


func create_egg(parent1: PigeonData, parent2: PigeonData = null) -> EggData:
	var egg := parent1.egg_template.duplicate(true)
	return egg


#func create_from_egg(egg: EggData) -> Pigeon
#
#func breed(mother: PigeonData, father: PigeonData) -> Pigeon
