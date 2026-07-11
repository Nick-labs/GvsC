class_name FarmUI
extends CanvasLayer

signal shop_pressed
signal defense_pressed


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_shop_button_pressed():
	shop_pressed.emit()


func _on_defense_button_pressed():
	defense_pressed.emit()
