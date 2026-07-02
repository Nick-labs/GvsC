class_name Pigeon
extends Area2D


signal clicked(pigeon: Pigeon)


@export var data: PigeonData

@export var sprites: Array[Texture2D]

@onready var sprite: Sprite2D = $Sprite2D

var cell: Cell


func _ready() -> void:
	update_view()
	

	# Это и так сделано через инспектор сигналов. Может, стоит заменить на это:
	#input_event.connect(_on_input_event)
	#mouse_entered.connect(_on_mouse_entered)
	#mouse_exited.connect(_on_mouse_exited)

func update_view():
	pass

func apply_random_sprite():
	var sprite := $Sprite2D

	sprite.texture = sprites.pick_random()
	
	fit_to_size(Vector2(200, 200))

func fit_to_size(target_size: Vector2) -> void:
	var sprite := $Sprite2D
	
	sprite.position += Vector2(15, 10)
	
	if sprite.texture == null:
		return

	var texture_size = sprite.texture.get_size()

	var scale_factor = min(
		target_size.x / texture_size.x,
		target_size.y / texture_size.y
	)

	sprite.scale = Vector2.ONE * scale_factor

func _on_mouse_entered() -> void:
	pass


func _on_mouse_exited() -> void:
	pass


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		clicked.emit(self)
