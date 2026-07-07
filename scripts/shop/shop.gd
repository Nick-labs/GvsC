extends Node2D

signal farm_pressed

var active := true


func _on_back_button_pressed() -> void:
	farm_pressed.emit()


func set_active(value: bool):
	active = value
