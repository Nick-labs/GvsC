extends Node2D

@onready var sell_all_button = $ButtonsContainer/SellAllButton
@onready var assortment_button = $ButtonsContainer/AssortmentButton
@onready var back_button = $ButtonsContainer/BackButton
@onready var assortment_popup = $AssortmentPopup  # Теперь это CanvasLayer

func _ready():
	if sell_all_button:
		sell_all_button.pressed.connect(_on_sell_all_pressed)
	if assortment_button:
		assortment_button.pressed.connect(_on_assortment_pressed)
	if back_button:
		back_button.pressed.connect(_on_back_button_pressed)

func _on_sell_all_pressed():
	if Inventory.eggs.is_empty() and Inventory.pigeons.is_empty():
		print("В рюкзаке нет яиц и голубей!")
		return
	
	var result = Inventory.sell_eggs_and_pigeons()
	var message = "=== ПРОДАЖА ВСЕГО ===\n\n"
	
	for item_name in result["sold_items"].keys():
		var data = result["sold_items"][item_name]
		message += "%s (%s): %s грошей\n" % [item_name, data["category"], data["price"]]
	
	message += "\nВсего получено: %s грошей" % result["total_earned"]
	print(message)

func _on_assortment_pressed():
	if assortment_popup:
		assortment_popup.open_centered()
	else:
		print("Ошибка: окно ассортимента не найдено!")

func _on_back_button_pressed() -> void:
	SceneManager.change_scene("farm")
	
func _on_close_button_pressed() -> void:
	assortment_popup.hide()
