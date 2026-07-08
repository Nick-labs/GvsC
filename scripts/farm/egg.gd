class_name Egg
extends Area2D

signal collected(egg: Egg)

var data: EggData
var collected_already := false

@onready var sprite = $Sprite2D


func _ready():
	mouse_entered.connect(_on_mouse_entered)


func setup(new_data: EggData):
	data = new_data
	sprite.texture = data.texture


func _on_mouse_entered():
	if collected_already:
		return

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		collected.emit(self)
