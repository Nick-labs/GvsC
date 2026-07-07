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
var egg_timer: float = 0.0
var can_lay_egg: bool = true

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	_apply_data()
	
	# Это и так сделано через инспектор сигналов
	# Может, стоит заменить на это:
	#input_event.connect(_on_input_event)
	#mouse_entered.connect(_on_mouse_entered)
	#mouse_exited.connect(_on_mouse_exited)


func _process(delta: float) -> void:
	if cell == null:
		return

	egg_timer += delta

	if egg_timer >= data.egg_interval:
		egg_timer = 0.0
		lay_egg()


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
