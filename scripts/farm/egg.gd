class_name Egg
extends Area2D

var data: EggData

@onready var sprite = $Sprite2D


func setup(new_data: EggData):
	data = new_data
	sprite.texture = data.texture


func hatch():
	pass
