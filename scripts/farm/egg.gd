class_name Egg
extends Area2D

signal drag_requested(egg: Egg)

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


func _on_input_event(
		_viewport: Node,
		event: InputEvent,
		_shape_idx: int
	):
	
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_RIGHT \
	and event.pressed:
		
		drag_requested.emit()


func setup(new_data: EggData):
	data = new_data
	sprite.texture = data.texture


func hatch():
	pass
	#if get_parent() is Cell:
		#var cell := get_parent() as Cell
		#cell.hatch_egg(self)
