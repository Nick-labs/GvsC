class_name Egg
extends Area2D


var value: int = 0

@onready var sprite: Sprite2D = $Sprite2D


func setup(data: EggData) -> void:
	value = data.value
	sprite.texture = data.texture
