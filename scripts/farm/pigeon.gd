class_name Pigeon
extends Area2D


signal clicked(pigeon: Pigeon)


@export var data: PigeonData

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


func _on_mouse_entered() -> void:
	pass


func _on_mouse_exited() -> void:
	pass


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:
		clicked.emit(self)
