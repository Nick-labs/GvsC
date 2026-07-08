extends CanvasLayer

const ItemData = preload("res://scripts/shop/item_data.gd")

var panel = null
var items_list = null
var close_button = null


func _ready():
	_create_ui()
	hide()
	
	Inventory.inventory_updated.connect(_update_display)


func _create_ui():
	for child in get_children():
		child.queue_free()
	
	var bg_overlay = ColorRect.new()
	bg_overlay.color = Color(0, 0, 0, 0.6)
	bg_overlay.size = get_viewport().get_visible_rect().size
	bg_overlay.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(bg_overlay)
	
	bg_overlay.gui_input.connect(_on_bg_click)
	
	panel = Panel.new()
	panel.size = Vector2(600, 450)
	panel.position = (get_viewport().get_visible_rect().size - panel.size) / 2
	panel.add_theme_stylebox_override("panel", StyleBoxFlat.new())
	add_child(panel)
	
	var main_vbox = VBoxContainer.new()
	main_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	main_vbox.size_flags_vertical = Control.SIZE_EXPAND_FILL
	main_vbox.add_theme_constant_override("separation", 10)
	panel.add_child(main_vbox)
	
	var title = Label.new()
	title.text = "🎒 РЮКЗАК"
	title.add_theme_color_override("font_color", Color(1, 0.8, 0))
	title.add_theme_font_size_override("font_size", 24)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	main_vbox.add_child(title)
	
	var separator = HSeparator.new()
	main_vbox.add_child(separator)
	
	var scroll = ScrollContainer.new()
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.custom_minimum_size = Vector2(0, 250)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_AUTO
	main_vbox.add_child(scroll)
	
	items_list = VBoxContainer.new()
	items_list.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	items_list.size_flags_vertical = Control.SIZE_EXPAND_FILL
	items_list.custom_minimum_size = Vector2(560, 0)
	scroll.add_child(items_list)
	
	var close_hbox = HBoxContainer.new()
	close_hbox.alignment = HORIZONTAL_ALIGNMENT_CENTER
	main_vbox.add_child(close_hbox)
	
	close_button = Button.new()
	close_button.text = "Закрыть"
	close_button.custom_minimum_size = Vector2(120, 40)
	close_button.add_theme_font_size_override("font_size", 16)
	close_button.pressed.connect(_on_close_pressed)
	close_hbox.add_child(close_button)
	
	_update_display()


func _on_bg_click(event: InputEvent):
	if event is InputEventMouseButton and event.pressed:
		hide()


func _update_display():
	if not items_list:
		return
	
	for child in items_list.get_children():
		child.queue_free()
	
	var has_items = false
	
	for item in Inventory.consumables:
		var item_name = item["name"]
		var quantity = item["quantity"]
		var data = item["data"]
		
		if quantity > 0:
			has_items = true
			var item_line = _create_item_line(item_name, quantity, data)
			items_list.add_child(item_line)
	
	if not has_items:
		var empty_label = Label.new()
		empty_label.text = "Рюкзак пуст"
		empty_label.add_theme_color_override("font_color", Color(0.5, 0.5, 0.5))
		empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		empty_label.add_theme_font_size_override("font_size", 18)
		items_list.add_child(empty_label)


func _create_item_line(item_name: String, quantity: int, data) -> HBoxContainer:
	var line = HBoxContainer.new()
	line.add_theme_constant_override("separation", 10)
	line.custom_minimum_size = Vector2(0, 40)
	line.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var name_label = Label.new()
	name_label.text = "📦 " + item_name
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	name_label.add_theme_color_override("font_color", Color(1, 1, 1))
	name_label.add_theme_font_size_override("font_size", 16)
	name_label.autowrap_mode = TextServer.AUTOWRAP_OFF
	line.add_child(name_label)
	
	var qty_label = Label.new()
	qty_label.text = "×%s" % quantity
	qty_label.add_theme_color_override("font_color", Color(0.7, 0.7, 0.7))
	qty_label.add_theme_font_size_override("font_size", 14)
	qty_label.custom_minimum_size = Vector2(50, 0)
	line.add_child(qty_label)
	
	if data and data.usable:
		var use_btn = Button.new()
		use_btn.text = "Использовать"
		use_btn.custom_minimum_size = Vector2(100, 28)
		use_btn.add_theme_font_size_override("font_size", 12)
		use_btn.mouse_filter = Control.MOUSE_FILTER_STOP
		use_btn.pressed.connect(_on_use_pressed.bind(item_name, data))
		line.add_child(use_btn)
	
	# Кнопка Инфо
	var info_btn = Button.new()
	info_btn.text = "ℹ️"
	info_btn.custom_minimum_size = Vector2(35, 28)
	info_btn.add_theme_font_size_override("font_size", 14)
	info_btn.mouse_filter = Control.MOUSE_FILTER_STOP
	info_btn.pressed.connect(_on_info_pressed.bind(item_name, data))
	line.add_child(info_btn)
	
	return line


func _on_use_pressed(item_name: String, data):
	if not data.usable:
		print("%s нельзя использовать!" % item_name)
		return
	
	var quantity = 0
	for item in Inventory.consumables:
		if item["name"] == item_name:
			quantity = item["quantity"]
			break
	
	if quantity <= 0:
		print("Нет %s в инвентаре!" % item_name)
		return
	
	match data.effect_type:
		"feed":
			print("🍽️ Покормили голубей! +%s сытости" % data.effect_value)
		"heal":
			print("💊 Вылечили голубей! +%s здоровья" % data.effect_value)
		"ENERGY":
			print("⚡ Использовали %s! +%s энергии" % [item_name, data.effect_value])
		_:
			print("Использовали %s" % item_name)
	
	Inventory.remove_item(Inventory.CATEGORY_CONSUMABLES, item_name, 1)
	_update_display()


func _on_info_pressed(item_name: String, data):
	print("ℹ️ Нажата Инфо для: ", item_name)
	
	var popup = AcceptDialog.new()
	popup.title = "📦 " + item_name
	popup.dialog_text = ""
	
	if data:
		popup.dialog_text += "Описание: %s\n" % data.description
		popup.dialog_text += "Цена: %s грошей\n" % data.price
		if data.usable:
			popup.dialog_text += "Можно использовать\n"
			popup.dialog_text += "Эффект: %s (+%s)" % [data.effect_type, data.effect_value]
		else:
			popup.dialog_text += "Нельзя использовать"
	else:
		popup.dialog_text = "Нет информации"
	
	get_tree().root.add_child(popup)
	popup.popup_centered()
	popup.close_requested.connect(popup.queue_free)


func _on_close_pressed():
	hide()


func open_centered():
	_update_display()
	show()
