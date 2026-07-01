class_name Loft
extends Node2D

signal pigeon_selected(pigeon: Pigeon)

@export var rows: int = 4
@export var columns: int = 5

@export var cell_size := Vector2(200, 200)

@export var cell_scene: PackedScene
@export var pigeon_scene: PackedScene

@onready var cells_root: Node2D = $Cells

var cells: Array[Cell] = []


func _ready() -> void:
	generate_cells()


func generate_cells() -> void:
	cells.clear()
	
	for row in rows:
		for column in columns:
		
			var cell := cell_scene.instantiate() as Cell
			
			cells_root.add_child(cell)
			
			cell.position = Vector2(
				column * cell_size.x + column * 10,
				row * cell_size.y + row * 10
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
	var pigeon := pigeon_scene.instantiate() as Pigeon

	pigeon.data = PigeonData.new()
	pigeon.clicked.connect(_on_pigeon_clicked)
	
	return pigeon


func _on_pigeon_clicked(pigeon: Pigeon) -> void:
	pigeon_selected.emit(pigeon)
