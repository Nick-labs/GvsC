extends Area2D

@export var data: PigeonData

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	update_view()

	input_event.connect(_on_input_event)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func update_view():
	pass# will be added later


func _on_mouse_entered() -> void:
	print("Навели")


func _on_mouse_exited() -> void:
	print("Отвели")


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		print("Выбран голубь")
