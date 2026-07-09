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
