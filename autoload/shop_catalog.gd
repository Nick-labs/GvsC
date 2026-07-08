class_name ShopCatalog
extends Resource

@export var offers: Array[ShopOffer]

var current_offers: Array[ShopOffer] = []


func generate_assortment():
	current_offers = offers.duplicate()


func get_current_offers() -> Array[ShopOffer]:
	if current_offers.is_empty():
		generate_assortment()

	return current_offers
