extends Node

@export var offers: Array[ShopOffer]

var current_offers: Array[ShopOffer] = []


func get_current_offers() -> Array[ShopOffer]:
	return current_offers


func generate_assortment():
	current_offers.clear()
	current_offers = offers.duplicate()
