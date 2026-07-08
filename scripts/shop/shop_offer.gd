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

# Сюда будем класть PigeonData, ItemData, UpgradeData
@export var data: Resource
