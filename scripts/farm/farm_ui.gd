class_name FarmUI
extends CanvasLayer

@onready var money_label: Label = $MarginContainer/MoneyLabel


func set_money(amount: int) -> void:
	money_label.text = "%d грошей" % amount


func _on_exit_button_pressed() -> void:
	get_tree().quit()
