class_name Shopkeeper
extends Area2D

signal clicked

@export var normal_texture: Texture2D
@export var embarrassed_texture: Texture2D

@onready var sprite: Sprite2D = $Sprite2D


func _ready():
	clicked.connect(_on_clicked)


func _on_input_event(
	_viewport,
	event,
	_shape_idx
):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		clicked.emit()


func _on_clicked():
	embarrassed()


func embarrassed():
	sprite.texture = embarrassed_texture
	
	AudioManager.play_sound("shopkeeper")
	
	var tween := create_tween()

	tween.tween_property(
		self,
		"rotation",
		0.03,
		0.1
	)

	tween.tween_property(
		self,
		"rotation",
		-0.03,
		0.1
	)

	tween.tween_property(
		self,
		"rotation",
		0.0,
		0.1
	)
	
	await get_tree().create_timer(1.0).timeout
	
	sprite.texture = normal_texture
