class_name ShopOffer
extends Resource

enum OfferType {
	PIGEON,
	ITEM,
	UPGRADE,
}

@export var title: String
@export_multiline var description: String

@export var icon: Texture2D
@export var price: int

@export var type: OfferType

@export var tier: int = 0

# Сюда будем класть PigeonData, ItemData, UpgradeData
@export var data: Resource


func is_pigeon_offer() -> bool:
	return type == OfferType.PIGEON


func is_item_offer() -> bool:
	return type == OfferType.ITEM


func is_upgrade_offer() -> bool:
	return type == OfferType.UPGRADE


func get_price() -> int:
	if data is UpgradeData:
		var upgrade := data as UpgradeData
		return upgrade.get_price(
			PlayerData.get_upgrade_level(upgrade.type)
		)

	return price
