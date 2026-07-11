extends Node


func buy(offer: ShopOffer) -> bool:
	var price := offer.get_price()
	
	if PlayerData.money < price:
		return false

	PlayerData.money -= price

	match offer.type:
		ShopOffer.OfferType.PIGEON:
			_buy_pigeon(offer)

		#ShopOffer.OfferType.ITEM:
			#_buy_item(offer)

		ShopOffer.OfferType.UPGRADE:
			_buy_upgrade(offer)
	
	return true


func _buy_pigeon(offer: ShopOffer):
	var pigeon_data := offer.data as PigeonData

	PlayerData.add_pigeon(
		pigeon_data.duplicate(true)
	)

#func _buy_item(offer: ShopOffer):
	#var item_data := offer.data as ItemData
#
	#PlayerData.add_item(
		#item_data.duplicate(true)
	#)

func _buy_upgrade(offer: ShopOffer):
	var upgrade = offer.data as UpgradeData

	match upgrade.type:

		UpgradeData.UpgradeType.BACKPACK_CAPACITY:
			PlayerData.upgrades.backpack_capacity += upgrade.value
			PlayerData.upgrades.backpack_level += 1

		UpgradeData.UpgradeType.BASKET_CAPACITY:
			PlayerData.upgrades.basket_capacity += upgrade.value
			PlayerData.upgrades.basket_level += 1
		
		UpgradeData.UpgradeType.NEST_CAPACITY:
			PlayerData.upgrades.nest_capacity += upgrade.value
			PlayerData.upgrades.nest_level += 1
		
		UpgradeData.UpgradeType.CELL:
			PlayerData.upgrades.unlocked_cells += 1
			PlayerData.upgrades.cell_level += 1

		UpgradeData.UpgradeType.INCUBATOR:
			PlayerData.upgrades.unlocked_incubators += 1
			PlayerData.upgrades.incubator_level += 1
	
	PlayerData.upgrades_updated()
