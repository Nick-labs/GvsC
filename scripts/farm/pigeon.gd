class_name Pigeon
extends Area2D

signal clicked(pigeon: Pigeon)
signal drag_requested(pigeon: Pigeon)
signal egg_laid(pigeon: Pigeon)

@export var data: PigeonData:
	set(value):
		data = value

		if is_node_ready():
			_apply_data()

var cell: Cell
var minutes_until_next_egg: int
var can_lay_egg: bool = true

@onready var sprite: Sprite2D = $Sprite2D


func _ready():
	_apply_data()

	minutes_until_next_egg = data.egg_interval_minutes

	#TimeManager.minute_passed.connect(_on_minute_passed)


func _enter_tree():
	if !TimeManager.minute_passed.is_connected(_on_minute_passed):
		TimeManager.minute_passed.connect(_on_minute_passed)


func _on_minute_passed(day: int, hour: int, minute: int) -> void:
	if cell == null:
		return

	if !can_lay_egg:
		return
	
	minutes_until_next_egg -= 1

	if minutes_until_next_egg <= 0:
		lay_egg()
		minutes_until_next_egg = data.egg_interval_minutes


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				clicked.emit(self)
			
			MOUSE_BUTTON_RIGHT:
				drag_requested.emit(self)


func _apply_data():
	if data == null:
		return
	
	sprite.texture = data.sprite
	fit_to_size(Vector2(200, 200))


func lay_egg():
	if !cell.can_receive_egg():
		return
	
	var egg: EggData = PigeonFactory.create_egg(data)
	
	cell.receive_egg(egg)
	data.eggs_laid += 1
	egg_laid.emit(self)


func fit_to_size(target_size: Vector2) -> void:
	if sprite == null:
		sprite = $Sprite2D
	
	sprite.position += Vector2(15, 10)
	
	if sprite.texture == null:
		return

	var texture_size = sprite.texture.get_size()

	var scale_factor = min(
		target_size.x / texture_size.x,
		target_size.y / texture_size.y
	)

	sprite.scale = Vector2.ONE * scale_factor


func _exit_tree():
	if TimeManager.minute_passed.is_connected(_on_minute_passed):
		TimeManager.minute_passed.disconnect(_on_minute_passed)
