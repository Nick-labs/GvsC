class_name Egg
extends Area2D

@export var basket: EggBasket

@onready var sprite = $Sprite2D


var data: EggData
var timer := 0.0


#func _ready() -> void:
	#input_event.connect(_on_input_event)
	

func _process(delta):
	timer += delta
	if timer >= data.hatch_time:
		hatch()


func setup(new_data: EggData):
	data = new_data
	sprite.texture = data.texture


func hatch():
	pass
	#if get_parent() is Cell:
		#var cell := get_parent() as Cell
		#cell.hatch_egg(self)
