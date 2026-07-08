class_name Backpack
extends Resource

@export var max_capacity: int = 10

var eggs: Array[EggData] = []
var pigeons: Array[PigeonData] = []


func get_used_space() -> int:
	return eggs.size() + pigeons.size()

func has_space(amount := 1) -> bool:
	return get_used_space() + amount <= max_capacity
