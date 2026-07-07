class_name FarmUI
extends CanvasLayer

@onready var money_label: Label = $MarginContainer/MoneyLabel


func set_money(amount: int) -> void:
	money_label.text = "%d грошей" % amount


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_shop_button_pressed():
	SceneManager.change_scene("shop")


func _on_defense_button_pressed():
	SceneManager.change_scene("defense")
