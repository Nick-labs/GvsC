class_name Farm
extends Node2D

@onready var loft: Loft = $Loft
@onready var farm_ui: FarmUI = $FarmUi

@export var padding: float = 300.0

var money: int = 100

var selected_pigeon: Pigeon = null


func _ready() -> void:
	loft.pigeon_selected.connect(_on_pigeon_selected)
	farm_ui.sell_pressed.connect(_on_sell_pressed)
	_fit_loft_to_screen()


#func update_ui():
	#if selected_pigeon == null:
		#selected_panel.hide()
	#else:
		#selected_panel.show()


#func _fit_loft_to_screen() -> void:
#
	#var screen := get_viewport_rect().size
#
	#var grid_width = (loft.columns - 1) * loft.cell_size.x
	#var grid_height = (loft.rows - 1) * loft.cell_size.y
#
	#var s = min(
		#(screen.x - padding * 2) / grid_width,
		#(screen.y - padding * 2) / grid_height
	#)
#
	#loft.scale = Vector2(s, s)
#
	#loft.position = screen / 2.0 - Vector2(grid_width, grid_height) * s / 2.0


func _fit_loft_to_screen() -> void:

	var screen := get_viewport_rect().size
	print(screen)
	print(loft.loft_size)
	
	#loft.position = (screen - Vector2(loft.loft_size)) / 2 + Vector2(100, 100)
	
	loft.position = (screen - Vector2(loft.loft_size)) / 2 + Vector2(100, 0)

func _on_pigeon_selected(pigeon: Pigeon) -> void:

	if selected_pigeon:
		_set_selected(selected_pigeon, false)

	selected_pigeon = pigeon
	
	_set_selected(selected_pigeon, true)

	farm_ui.show_pigeon(selected_pigeon)


func _set_selected(pigeon: Pigeon, value: bool) -> void:
	if value:
		pigeon.modulate = Color(1.5, 1.5, 1.5, 1.0)
	else:
		pigeon.modulate = Color.WHITE


func _on_sell_pressed() -> void:
	if selected_pigeon == null:
		return
	
	money += selected_pigeon.data.price

	selected_pigeon.cell.remove_pigeon()

	selected_pigeon = null

	farm_ui.clear_selection()
