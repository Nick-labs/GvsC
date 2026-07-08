extends Node

@export var hatchable_species: Array[PigeonData]
@export var shop_species: Array[PigeonData]

var hatchable_by_tier: Dictionary = {}
var shop_by_tier: Dictionary = {}

const MAX_TIER := 5
const MIN_TIER := 0


func _ready():
	_build_dictionary(hatchable_species, hatchable_by_tier)
	_build_dictionary(shop_species, shop_by_tier)


func _build_dictionary(source: Array[PigeonData], target: Dictionary) -> void:
	target.clear()

	for pigeon in source:
		if !target.has(pigeon.tier):
			target[pigeon.tier] = []

		target[pigeon.tier].append(pigeon)


func _get_random_from_dictionary(dictionary: Dictionary, tier: int) -> PigeonData:
	if !dictionary.has(tier):
		return null

	var list: Array[PigeonData] = dictionary[tier]

	if list.is_empty():
		return null

	return list.pick_random()


func get_random_hatchable_species(tier: int) -> PigeonData:
	return _get_random_from_dictionary(hatchable_by_tier, tier)


func get_random_shop_species(tier: int) -> PigeonData:
	return _get_random_from_dictionary(shop_by_tier, tier)


func _get_species_of_tier(dictionary: Dictionary, tier: int) -> Array[PigeonData]:
	if !dictionary.has(tier):
		return []

	return dictionary[tier]


func get_hatchable_species_of_tier(tier: int) -> Array[PigeonData]:
	return _get_species_of_tier(hatchable_by_tier, tier)


func get_shop_species_of_tier(tier: int) -> Array[PigeonData]:
	return _get_species_of_tier(shop_by_tier, tier)


func get_random_species_of_tier(tier: int) -> PigeonData:
	var candidates: Array[PigeonData] = []

	candidates.append_array(get_hatchable_species_of_tier(tier))
	candidates.append_array(get_shop_species_of_tier(tier))

	if candidates.is_empty():
		return null

	return candidates.pick_random()


func get_random_hatchable_by_egg(egg: EggData) -> PigeonData:
	var tier := _roll_tier(egg)
	return get_random_hatchable_species(tier)


func _roll_tier(egg: EggData) -> int:
	var roll := randf() * 100.0
	var accumulated := 0.0

	for chance in egg.hatch_chances:
		accumulated += chance.chance

		if roll <= accumulated:
			return clamp(
				egg.tier + chance.tier_offset,
				MIN_TIER,
				MAX_TIER
			)

	return egg.tier
