class_name Loft
extends Node2D

signal pigeon_clicked(pigeon: Pigeon)
signal pigeon_drag_requested(pigeon: Pigeon)
signal pigeon_egg_laid(pigeon: Pigeon)

@export var rows: int = 3
@export var columns: int = 6
@export var cell_size := Vector2i(200, 200)
@export var cell_space_x := 10
@export var cell_space_y := -15
@export var cell_scene: PackedScene
@export var pigeon_scene: PackedScene

var cells: Array[Cell] = []

var offset: Vector2 = Vector2(130, 40)

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
			) + offset
			
			cell.index = Vector2i(column, row)
			
			cells.append(cell)
	
	update_unlocked_cells()
	
	var pigeon := create_default_pigeon()
	cells[0].set_pigeon(pigeon)


func get_cell(index: int) -> Cell:
	if index >= PlayerData.upgrades.unlocked_cells:
		return null

	return cells[index]


func get_free_cell() -> Cell:
	for i in PlayerData.upgrades.unlocked_cells:
		var cell := cells[i]

		if cell.is_empty():
			return cell

	return null


func add_pigeon(pigeon: Pigeon) -> bool:
	var cell := get_free_cell()
	
	if cell == null:
		return false
		
	cell.set_pigeon(pigeon)
	
	return true


func update_unlocked_cells():
	for i in cells.size():
		cells[i].nest_sprite.visible = i < PlayerData.upgrades.unlocked_cells


func create_default_pigeon() -> Pigeon:
	var pigeon: Pigeon = PigeonFactory.create_from_template(SpeciesRegistry.get_random_hatchable_species(0))
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
	for i in PlayerData.upgrades.unlocked_cells:
		var cell := cells[i]

		if cell.hovered:
			return cell

	return null


func _on_pigeon_clicked(pigeon: Pigeon) -> void:
	pigeon_clicked.emit(pigeon)


func _on_pigeon_drag_requested(pigeon: Pigeon):
	pigeon_drag_requested.emit(pigeon)


func _on_pigeon_egg_laid(pigeon: Pigeon):
	pigeon_egg_laid.emit(pigeon)
