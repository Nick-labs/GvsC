class_name UpgradeData
extends Resource

enum UpgradeType {
	BACKPACK_CAPACITY,
	BASKET_CAPACITY,
	NEST_CAPACITY,
	CELL,
	INCUBATOR,
}

@export var type: UpgradeType
@export var value: int = 1

@export_group("Price")
@export var base_price := 200
@export var price_step := 100


func get_price(level: int) -> int:
	return base_price + level * price_step
