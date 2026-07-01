class_name Farm
extends Node2D

@onready var loft: Loft = $Loft

@export var padding: float = 100.0

var selected_pigeon: Pigeon = null


func _ready() -> void:
	loft.pigeon_selected.connect(_on_pigeon_selected)
	_fit_loft_to_screen()


func _fit_loft_to_screen() -> void:

	var grid_width = (loft.columns - 1) * loft.cell_size.x
	var grid_height = (loft.rows) * loft.cell_size.y

	var screen_size := get_viewport_rect().size

	var available_width = screen_size.x - padding * 2
	var available_height = screen_size.y - padding * 2

	var scale_x = available_width / grid_width
	var scale_y = available_height / grid_height

	var s = min(scale_x, scale_y)

	loft.scale = Vector2(s, s)
	
	loft.position = screen_size / 2.0
	loft.position -= Vector2(grid_width, grid_height) * s / 2.0


func _on_pigeon_selected(pigeon: Pigeon) -> void:
	
	if selected_pigeon:
		_set_selected(selected_pigeon, false)
	
	selected_pigeon = pigeon
	_set_selected(selected_pigeon, true)


func _set_selected(pigeon: Pigeon, value: bool) -> void:
	if value:
		pigeon.modulate = Color(1.2, 1.2, 1.2)
	else:
		pigeon.modulate = Color.WHITE
