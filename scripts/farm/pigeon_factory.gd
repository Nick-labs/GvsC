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


#func create_from_egg(egg: EggData) -> Pigeon
#
#func breed(mother: PigeonData, father: PigeonData) -> Pigeon
