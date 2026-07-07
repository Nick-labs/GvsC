extends Node2D

var active := true


func _on_back_button_pressed() -> void:
	SceneManager.change_scene("farm")


func set_active(value: bool):
	active = value
