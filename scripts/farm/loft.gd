class_name Loft
extends Node2D

signal pigeon_clicked(pigeon: Pigeon)
signal pigeon_drag_requested(pigeon: Pigeon)
signal pigeon_egg_laid(pigeon: Pigeon)

@export var rows: int = 2
@export var columns: int = 5
@export var cell_size := Vector2i(200, 200)
@export var cell_space_x := 60
@export var cell_space_y := 30
@export var cell_scene: PackedScene
@export var pigeon_scene: PackedScene

var loft_size := Vector2i(cell_size.x * columns + cell_space_x * (columns - 1),
 						  cell_size.y * rows + cell_space_y * (rows - 1))

var cells: Array[Cell] = []

@onready var cells_root: Node2D = $Cells
@onready var marker: Marker2D = $Cells/Marker2D


func _ready() -> void:
	generate_cells()


func generate_cells() -> void:
	cells.clear()
	
	for row in rows:
		for column in columns:
			var cell := cell_scene.instantiate() as Cell

			cells_root.add_child(cell)
			
			cell.position = marker.position + Vector2(
				column * cell_size.x + column * cell_space_x,
				row * cell_size.y + row * cell_space_y
			)
			
			cell.index = Vector2i(column, row)
			
			var pigeon := create_default_pigeon()
			cell.set_pigeon(pigeon)
			
			cells.append(cell)


func get_cell(index: int) -> Cell:
	return cells[index]


func get_free_cell() -> Cell:
	for cell in cells:
		if cell.is_empty():
			return cell
	return null


func add_pigeon(pigeon: Pigeon) -> bool:
	var cell := get_free_cell()
	
	if cell == null:
		return false
		
	cell.set_pigeon(pigeon)
	
	return true


func create_default_pigeon() -> Pigeon:
	var pigeon: Pigeon = PigeonFactory.create_start_pigeon()
	setup_pigeon(pigeon)
	return pigeon


func setup_pigeon(pigeon: Pigeon):
	if not pigeon.clicked.is_connected(_on_pigeon_clicked):
		pigeon.clicked.connect(_on_pigeon_clicked)

	if not pigeon.drag_requested.is_connected(_on_pigeon_drag_requested):
		pigeon.drag_requested.connect(_on_pigeon_drag_requested)

	if not pigeon.egg_laid.is_connected(_on_pigeon_egg_laid):
		pigeon.egg_laid.connect(_on_pigeon_egg_laid)


func get_hovered_cell() -> Cell:
	for cell in cells:
		if cell.hovered:
			return cell
	
	return null


func _on_pigeon_clicked(pigeon: Pigeon) -> void:
	pigeon_clicked.emit(pigeon)


func _on_pigeon_drag_requested(pigeon: Pigeon):
	pigeon_drag_requested.emit(pigeon)


func _on_pigeon_egg_laid(pigeon: Pigeon):
	pigeon_egg_laid.emit(pigeon)
