class_name Backpack
extends Resource

@export var capacity: int = 20

var eggs: Array[EggData] = []
var pigeons: Array[PigeonData] = []


func get_used_space() -> int:
	#return eggs.size() + pigeons.size()
	return eggs.size()
	


func get_free_space() -> int:
	return capacity - get_used_space()


func has_space(amount: int = 1) -> bool:
	return get_used_space() + amount <= capacity


func add_egg(egg: EggData) -> bool:
	if not has_space():
		return false

	eggs.append(egg)
	return true


func add_pigeon(pigeon: PigeonData) -> bool:
	#if not has_space():
		#return false

	pigeons.append(pigeon)
	return true


func remove_egg(egg: EggData):
	eggs.erase(egg)


func remove_pigeon(pigeon: PigeonData):
	pigeons.erase(pigeon)
