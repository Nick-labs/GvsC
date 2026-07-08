extends CanvasLayer

const ItemData = preload("res://scripts/shop/item_data.gd")

@export var Kofe: ItemData

var shop_items = []
var panel = null
var close_button = null

func _ready():
	_initialize_shop_items()
	_create_ui()
	hide()

func _create_ui():
	# Удаляем старые узлы
	for child in get_children():
		child.queue_free()
	
	# Затемняющий фон
	var bg_overlay = ColorRect.new()
	bg_overlay.color = Color(0, 0, 0, 0.5)
	bg_overlay.size = get_viewport().get_visible_rect().size
	bg_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(bg_overlay)
	
	# Главная панель
	panel = Panel.new()
	panel.size = Vector2(450, 400)
	panel.position = (get_viewport().get_visible_rect().size - panel.size) / 2
	panel.add_theme_stylebox_override("panel", StyleBoxFlat.new())
	add_child(panel)
	
	# VBoxContainer внутри панели
	var main_vbox = VBoxContainer.new()
	main_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_vbox.add_theme_constant_override("separation", 15)
	panel.add_child(main_vbox)
	
	# Заголовок
	var title = Label.new()
	title.text = "=== АССОРТИМЕНТ МАГАЗИНА ==="
	title.add_theme_color_override("font_color", Color(1, 0.8, 0))
	title.add_theme_font_size_override("font_size", 22)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER  # ← ИСПРАВЛЕНО
	main_vbox.add_child(title)
	
	# Разделитель
	var separator = HSeparator.new()
	main_vbox.add_child(separator)
	
	# ScrollContainer
	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.custom_minimum_size = Vector2(0, 200)
	main_vbox.add_child(scroll)
	
	# ItemsList
	var items_list = VBoxContainer.new()
	items_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(items_list)
	
	# Добавляем товары
	if shop_items.is_empty():
		var empty_label = Label.new()
		empty_label.text = "Товаров нет"
		empty_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
		empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER  # ← ИСПРАВЛЕНО
		items_list.add_child(empty_label)
	else:
		for item_data in shop_items:
			var item_name = item_data.item_name
			
			# Строка товара
			var item_line = HBoxContainer.new()
			item_line.add_theme_constant_override("separation", 10)
			item_line.custom_minimum_size = Vector2(0, 45)
			items_list.add_child(item_line)
			
			# Название
			var name_label = Label.new()
			name_label.text = item_name
			name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			name_label.add_theme_color_override("font_color", Color(1, 1, 1))
			name_label.add_theme_font_size_override("font_size", 18)
			item_line.add_child(name_label)
			
			# Цена
			var price_label = Label.new()
			price_label.text = "%s грошей" % item_data.price
			price_label.add_theme_color_override("font_color", Color(1, 0.8, 0))
			price_label.add_theme_font_size_override("font_size", 18)
			item_line.add_child(price_label)
			
			# Кнопка "Купить"
			var buy_button = Button.new()
			buy_button.text = "Купить"
			buy_button.custom_minimum_size = Vector2(80, 35)
			buy_button.add_theme_font_size_override("font_size", 14)
			buy_button.pressed.connect(_on_buy_button_pressed.bind(item_name, item_data))
			item_line.add_child(buy_button)
	
	# Кнопка "Закрыть"
	var close_hbox = HBoxContainer.new()
	close_hbox.alignment = HORIZONTAL_ALIGNMENT_CENTER  # ← ИСПРАВЛЕНО
	main_vbox.add_child(close_hbox)
	
	close_button = Button.new()
	close_button.text = "Закрыть"
	close_button.custom_minimum_size = Vector2(120, 40)
	close_button.add_theme_font_size_override("font_size", 16)
	close_button.pressed.connect(_on_close_pressed)
	close_hbox.add_child(close_button)

func _initialize_shop_items():
	if Kofe:
		shop_items.append(Kofe.duplicate())
		print("Кофе добавлен!")
	else:
		print("ОШИБКА: Kofe не задан!")
		var test_item = ItemData.new()
		test_item.item_name = "Тестовый товар"
		test_item.price = 10
		shop_items.append(test_item)

func _on_buy_button_pressed(item_name: String, item_data: ItemData):
	print("Покупка: %s за %s грошей" % [item_name, item_data.price])
	var new_item = item_data.duplicate_item()
	Inventory.add_item(Inventory.CATEGORY_CONSUMABLES, item_name, new_item, 1)

func _on_close_pressed():
	hide()

func open_centered():
	print("open_centered() вызван!")
	# Пересоздаем UI при открытии
	_create_ui()
	
	var viewport_size = get_viewport().get_visible_rect().size
	if panel:
		panel.position = (viewport_size - panel.size) / 2
	
	show()
	print("Окно открыто!")
