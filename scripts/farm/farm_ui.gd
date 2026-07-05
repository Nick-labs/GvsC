class_name FarmUI
extends CanvasLayer

signal sell_pressed

@onready var money_label: Label = $MarginContainer/MoneyLabel
@onready var name_label: Label = $MarginContainer/BottomPanel/HBoxContainer/NameLabel
@onready var price_label: Label = $MarginContainer/BottomPanel/HBoxContainer/PriceLabel
@onready var sell_button: Button = $MarginContainer/BottomPanel/HBoxContainer/SellButton


func set_money(amount: int) -> void:
	money_label.text = "%d грошей" % amount


func show_pigeon(pigeon: Pigeon) -> void:
	name_label.text = pigeon.data.name
	price_label.text = "Цена: %d" % pigeon.data.price


func clear_selection() -> void:
	name_label.text = "Голубь не выбран"
	price_label.text = "Цена: —"


func _on_sell_button_pressed() -> void:
	sell_pressed.emit()


func _on_exit_button_pressed() -> void:
	get_tree().quit()
