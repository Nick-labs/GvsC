class_name Pigeon
extends Area2D

signal clicked(pigeon: Pigeon)

@export var data: PigeonData
@export var sprites: Array[Texture2D]
@export var egg_interval: float = 7.0 + randf_range(-3, 3)
@export var egg_data: EggData

var cell: Cell
var egg_timer: float = 0.0
var can_lay_egg: bool = true

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	pass
	
	# Это и так сделано через инспектор сигналов
	# Может, стоит заменить на это:
	#input_event.connect(_on_input_event)
	#mouse_entered.connect(_on_mouse_entered)
	#mouse_exited.connect(_on_mouse_exited)


func _process(delta: float) -> void:
	if cell == null:
		return

	egg_timer += delta

	if egg_timer >= egg_interval:
		egg_timer = 0.0
		lay_egg()


func lay_egg() -> void:
	if cell == null:
		return

	cell.receive_egg(egg_data)


func apply_random_sprite():
	if sprite == null:
		sprite = $Sprite2D
		
	sprite.texture = sprites.pick_random()
	fit_to_size(Vector2(200, 200))


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


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		clicked.emit(self)
