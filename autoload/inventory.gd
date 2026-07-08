extends Node

signal inventory_updated

# Используем списки вместо словарей
var eggs = []        # Каждый элемент: {"name": "Белое", "data": EggData}
var pigeons = []     # Каждый элемент: {"name": "Почтовый", "data": PigeonData}
var consumables = [] # Каждый элемент: {"name": "Корм", "data": ItemData, "quantity": 10}

const CATEGORY_EGGS = "eggs"
const CATEGORY_PIGEONS = "pigeons"
const CATEGORY_CONSUMABLES = "consumables"

func _ready():
	_initialize_test_data()

func _initialize_test_data():
	# Яйца
	var egg1 = EggData.new()
	egg1.price = 10
	#egg1.hatch_time = 15.0
	eggs.append({"name": "Белое", "data": egg1})
	
	var egg2 = EggData.new()
	egg2.price = 15
	#egg2.hatch_time = 20.0
	eggs.append({"name": "Коричневое", "data": egg2})
	
	# Голуби
	var pigeon1 = PigeonData.new()
	pigeon1.breed_name = "Почтовый"
	pigeon1.price = 100
	pigeons.append({"name": "Почтовый", "data": pigeon1})
	
	var pigeon2 = PigeonData.new()
	pigeon2.breed_name = "Гончий"
	pigeon2.price = 150
	pigeons.append({"name": "Гончий", "data": pigeon2})
	
	# Расходники
	var food = ItemData.new()
	food.item_name = "Корм"
	food.price = 5
	food.item_type = "Food"
	food.description = "Корм для голубей"
	consumables.append({"name": "Корм", "data": food, "quantity": 10})

# ============ ПОИСК ПО ИМЕНИ ============

func find_item(list: Array, item_name: String) -> int:
	for i in range(list.size()):
		if list[i]["name"] == item_name:
			return i
	return -1

# ============ МЕТОДЫ ДЛЯ РАБОТЫ С ИНВЕНТАРЕМ ============

func add_item(category: String, item_name: String, data, quantity: int = 1):
	var list = _get_category_list(category)
	if list == null:
		return false
	
	var index = find_item(list, item_name)
	
	if category == CATEGORY_CONSUMABLES:
		if index != -1:
			list[index]["quantity"] += quantity
		else:
			list.append({"name": item_name, "data": data, "quantity": quantity})
	else:
		if index == -1:
			list.append({"name": item_name, "data": data})
		else:
			list[index]["data"] = data  # Обновляем данные
	
	inventory_updated.emit()
	return true

func remove_item(category: String, item_name: String, quantity: int = 1):
	var list = _get_category_list(category)
	if list == null:
		return false
	
	var index = find_item(list, item_name)
	if index == -1:
		return false
	
	if category == CATEGORY_CONSUMABLES:
		if list[index]["quantity"] < quantity:
			return false
		list[index]["quantity"] -= quantity
		if list[index]["quantity"] <= 0:
			list.remove_at(index)
	else:
		list.remove_at(index)
	
	inventory_updated.emit()
	return true

func get_item_count(category: String, item_name: String) -> int:
	var list = _get_category_list(category)
	if list == null:
		return 0
	
	var index = find_item(list, item_name)
	if index == -1:
		return 0
	
	if category == CATEGORY_CONSUMABLES:
		return list[index]["quantity"]
	else:
		return 1

func get_category_items(category: String) -> Array:
	var list = _get_category_list(category)
	if list == null:
		return []
	return list.duplicate()

func get_total_items_count() -> int:
	var total = 0
	total += eggs.size()
	total += pigeons.size()
	for item in consumables:
		total += item["quantity"]
	return total

# ============ ПРОДАЖА ВСЕГО ============

func sell_eggs_and_pigeons() -> Dictionary:
	var total_earned = 0
	var sold_items = {}
	
	for egg in eggs:
		var name = egg["name"]
		var data = egg["data"]
		var price = data.price if data else 0
		sold_items[name] = {"category": "Яйца", "price": price}
		total_earned += price
	eggs.clear()
	
	for pigeon in pigeons:
		var name = pigeon["name"]
		var data = pigeon["data"]
		var price = data.price if data else 0
		sold_items[name] = {"category": "Голуби", "price": price}
		total_earned += price
	pigeons.clear()
	
	inventory_updated.emit()
	return {"sold_items": sold_items, "total_earned": total_earned}

# ============ ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ ============

func _get_category_list(category: String):
	match category:
		CATEGORY_EGGS: return eggs
		CATEGORY_PIGEONS: return pigeons
		CATEGORY_CONSUMABLES: return consumables
		_: return null
