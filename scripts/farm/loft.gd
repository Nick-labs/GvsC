class_name Loft
extends Node2D

signal pigeon_selected(pigeon: Pigeon)

@export var rows: int = 2
@export var columns: int = 5
@export var cell_size := Vector2i(200, 200)
@export var cell_space := 40
@export var cell_scene: PackedScene
@export var pigeon_scene: PackedScene

var loft_size := Vector2i(cell_size.x * columns + cell_space * (columns - 1),
 						  cell_size.y * rows + cell_space * (rows - 1))

var cells: Array[Cell] = []

@onready var cells_root: Node2D = $Cells


func _ready() -> void:
	generate_cells()


func generate_cells() -> void:
	cells.clear()
	
	for row in rows:
		for column in columns:
		
			var cell := cell_scene.instantiate() as Cell
			
			cells_root.add_child(cell)
			
			cell.position = Vector2(
				column * cell_size.x + column * cell_space,
				row * cell_size.y + row * cell_space
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
	var pigeon: Pigeon = PigeonFactory.create_random()
	pigeon.clicked.connect(_on_pigeon_clicked)
	return pigeon


func get_hovered_cell() -> Cell:
	for cell in cells:
		if cell.hovered:
			return cell
	
	return null


func _on_pigeon_clicked(pigeon: Pigeon) -> void:
	pigeon_selected.emit(pigeon)
