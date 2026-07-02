class_name FarmUI
extends CanvasLayer


signal sell_pressed


@onready var name_label: Label = $BottomPanel/HBoxContainer/NameLabel
@onready var price_label: Label = $BottomPanel/HBoxContainer/PriceLabel
@onready var sell_button: Button = $BottomPanel/HBoxContainer/SellButton


func show_pigeon(pigeon: Pigeon) -> void:
	name_label.text = pigeon.data.name
	price_label.text = "Цена: %d" % pigeon.data.price


func clear_selection() -> void:
	name_label.text = "Голубь не выбран"
	price_label.text = "Цена: —"


func _on_sell_button_pressed() -> void:
	sell_pressed.emit()
