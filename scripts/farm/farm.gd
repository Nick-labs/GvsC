class_name Farm
extends Node2D

@export var padding: float = 300.0

@onready var loft: Loft = $Loft
@onready var egg_basket: EggBasket = $EggBasket
@onready var farm_ui: FarmUI = $FarmUI
@onready var pigeon_inspector: PigeonInspector  = $FarmUI/MarginContainer/PigeonInspector


var money: int = 100:
	set(value):
		money = value
		if is_node_ready():
			farm_ui.set_money(money)

var selected_pigeon: Pigeon = null
var dragged_pigeon: Pigeon = null
var source_cell: Cell = null
var music_started := false


func _ready() -> void:
	loft.pigeon_clicked.connect(_on_pigeon_clicked)
	loft.pigeon_drag_requested.connect(_on_pigeon_drag_requested)
	loft.pigeon_egg_laid.connect(_on_pigeon_egg_laid)
	
	pigeon_inspector.sell_pressed.connect(_on_sell_pressed)
	
	farm_ui.set_money(money)
	
	_fit_loft_to_screen()


func _process(_delta):
	if dragged_pigeon == null:
		return

	dragged_pigeon.global_position = get_global_mouse_position()


func _input(event):
	if music_started:
		return

	#if event is InputEventMouseButton and event.pressed:
		#$MusicPlayer.play()
		#music_started = true


func _unhandled_input(event):
	if dragged_pigeon == null:
		return

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_RIGHT \
	and not event.pressed:
		finish_drag()
	

func _fit_loft_to_screen() -> void:
	var screen := get_viewport_rect().size
	loft.position = (screen - Vector2(loft.loft_size)) / 2 + Vector2(-200, 0)


func _on_pigeon_drag_requested(pigeon: Pigeon):
	select_pigeon(pigeon)
	start_drag()


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

	pigeon_inspector.clear()


func _on_pigeon_clicked(pigeon: Pigeon):
	collect_eggs(pigeon.cell)


func _on_pigeon_egg_laid(pigeon: Pigeon):
	if pigeon == selected_pigeon:
		pigeon_inspector.show_pigeon(pigeon)


func select_pigeon(pigeon: Pigeon):
	if selected_pigeon == pigeon:
		return

	if selected_pigeon:
		_set_selected(selected_pigeon, false)

	selected_pigeon = pigeon

	_set_selected(selected_pigeon, true)

	pigeon_inspector.show_pigeon(selected_pigeon)

	collect_eggs(pigeon.cell)


func start_drag():
	if selected_pigeon == null:
		return

	if dragged_pigeon:
		return

	dragged_pigeon = selected_pigeon
	source_cell = selected_pigeon.cell


func finish_drag():
	var target := loft.get_hovered_cell()
	
	if target == null:
		source_cell.set_pigeon(dragged_pigeon)
	
	elif target.is_empty():
		var pigeon = source_cell.take_pigeon()
		target.set_pigeon(pigeon)
	
	else:
		swap(source_cell, target)

	self.dragged_pigeon = null
	self.source_cell = null


func swap(a: Cell, b: Cell):
	var first = a.take_pigeon()
	var second = b.take_pigeon()

	a.set_pigeon(second)
	b.set_pigeon(first)


func collect_eggs(cell: Cell):
	for egg in cell.take_eggs():
		egg_basket.receive_egg(egg)
