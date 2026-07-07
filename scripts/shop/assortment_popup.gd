extends PopupPanel

const ItemData = preload("res://scripts/shop/item_data.gd")

@export var Kofe: ItemData
@onready var items_list = $VBoxContainer/ScrollContainer/VBoxContainer
@onready var close_button = $VBoxContainer/HBoxContainer/CloseButton

var shop_items = []

func _ready():
	_initialize_shop_items()
	if close_button:
		close_button.pressed.connect(_on_close_pressed)

func _initialize_shop_items():
	var food = ItemData.new()
	shop_items.append(Kofe.duplicate())

func _populate_assortment():
	if not items_list:
		return
	
	for child in items_list.get_children():
		child.queue_free()
	
	var title_label = Label.new()
	title_label.text = "=== АССОРТИМЕНТ МАГАЗИНА ==="
	title_label.add_theme_color_override("font_color", Color(1, 0.8, 0))
	title_label.add_theme_font_size_override("font_size", 16)
	items_list.add_child(title_label)
	
	for item_name in shop_items.keys():
		var item_data = shop_items[item_name]
		
		var item_line = HBoxContainer.new()
		item_line.add_theme_constant_override("separation", 10)
		
		var name_label = Label.new()
		name_label.text = item_name
		name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var price_label = Label.new()
		price_label.text = "%s грошей" % item_data.price
		price_label.add_theme_color_override("font_color", Color(1, 0.8, 0))
		
		var desc_label = Label.new()
		var desc = item_data.description
		if item_data.usable and item_data.effect_type != "":
			desc += " (Эффект: %s +%s)" % [item_data.effect_type, item_data.effect_value]
		desc_label.text = "(%s)" % desc
		desc_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
		desc_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		
		var buy_button = Button.new()
		buy_button.text = "Купить"
		buy_button.custom_minimum_size = Vector2(80, 30)
		buy_button.pressed.connect(_on_buy_button_pressed.bind(item_name, item_data))
		
		item_line.add_child(name_label)
		item_line.add_child(desc_label)
		item_line.add_child(price_label)
		item_line.add_child(buy_button)
		
		items_list.add_child(item_line)

func _on_buy_button_pressed(item_name: String, item_data: ItemData):
	print("Покупка: %s за %s грошей" % [item_name, item_data.price])
	var new_item = item_data.duplicate_item()
	Inventory.add_item(Inventory.CATEGORY_CONSUMABLES, item_name, new_item, 1)
	print("Добавлен расходник: %s" % item_name)

func _on_close_pressed():
	hide()

func open_centered():
	_populate_assortment()
	popup_centered()
