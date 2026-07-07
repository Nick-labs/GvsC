class_name ItemData
extends Resource

# Основные свойства
@export var item_name: String = "Предмет"
@export var description: String = ""
@export var price: int = 0
@export var icon: Texture2D

# Тип расходника
@export_enum("Food", "Tool", "Other") var item_type: String = "Other"

# Можно ли продать
#@export var sellable: bool = true

# Можно ли использовать
@export var usable: bool = false

# Эффекты при использовании
@export var effect_value: float = 0.0
@export var effect_type: String = ""

func get_display_name() -> String:
	return item_name

func get_full_description() -> String:
	var text = description
	if not text.is_empty():
		text += "\n"
	text += "Цена: %s грошей" % price
	
	if effect_value > 0 and not effect_type.is_empty():
		text += "\nЭффект: %s (+%s)" % [effect_type, effect_value]
	
	return text

func duplicate_item() -> ItemData:
	var dup = ItemData.new()
	dup.item_name = item_name
	dup.description = description
	dup.price = price
	dup.icon = icon
	dup.item_type = item_type
	dup.usable = usable
	dup.effect_value = effect_value
	dup.effect_type = effect_type
	return dup
