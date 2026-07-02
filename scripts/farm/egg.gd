class_name Egg
extends Area2D


@onready var sprite = $Sprite2D

@export var hatch_time := 15.0
var timer := 0.0

var data: EggData


func _process(delta):
	timer += delta
	if timer >= hatch_time:
		hatch()


func setup(new_data: EggData):
	data = new_data
	sprite.texture = data.texture


func hatch():
	if get_parent() is Cell:
		var cell := get_parent() as Cell
		cell.hatch_egg(self)
