class_name Egg
extends Area2D

@onready var sprite = $Sprite2D

var data: EggData
var timer := 0.0


func _process(delta):
	timer += delta
	if timer >= data.hatch_time:
		hatch()


func setup(new_data: EggData):
	data = new_data
	sprite.texture = data.texture


func hatch():
	if get_parent() is Cell:
		var cell := get_parent() as Cell
		cell.hatch_egg(self)
