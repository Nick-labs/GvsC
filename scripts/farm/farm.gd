class_name Farm
extends Node2D

@export var padding: float = 300.0

@onready var loft: Loft = $Loft
@onready var egg_basket: EggBasket = $EggBasket
@onready var incubator: Incubator = $Incubator
@onready var farm_ui: FarmUI = $FarmUI
@onready var pigeon_inspector: PigeonInspector  = $FarmUI/MarginContainer/PigeonInspector
@onready var drag_manager: DragManager = $DragManager


var money: int = 100:
	set(value):
		money = value
		if is_node_ready():
			farm_ui.set_money(money)

var selected_pigeon: Pigeon = null
var music_started := false


func _ready() -> void:
	egg_basket.egg_drag_requested.connect(_on_egg_drag_requested)
	incubator.egg_drag_requested.connect(
		_on_incubator_egg_drag_requested
	)
	
	loft.pigeon_clicked.connect(_on_pigeon_clicked)
	loft.pigeon_drag_requested.connect(_on_pigeon_drag_requested)
	loft.pigeon_egg_laid.connect(_on_pigeon_egg_laid)
	
	drag_manager.drag_finished.connect(_on_drag_finished)
	
	pigeon_inspector.sell_pressed.connect(_on_sell_pressed)
	
	farm_ui.set_money(money)
	
	_fit_loft_to_screen()


func _input(event):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_RIGHT \
	and event.pressed:

		try_start_egg_drag()
	
	if music_started:
		return

	#if event is InputEventMouseButton and event.pressed:
		#$MusicPlayer.play()
		#music_started = true


func try_start_egg_drag():
	var space := get_world_2d().direct_space_state

	var query := PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	query.collide_with_areas = true

	var results := space.intersect_point(query)

	var selected: Egg = null
	var max_z := -99999

	for result in results:
		var collider = result.collider

		if collider is Egg:
			if collider.z_index > max_z:
				selected = collider
				max_z = collider.z_index

	if selected:
		var slot := egg_basket.take_egg(selected)
		
		drag_manager.start_drag(
			selected,
			egg_basket,
			slot
		)


func _fit_loft_to_screen() -> void:
	var screen := get_viewport_rect().size
	loft.position = (screen - Vector2(loft.loft_size)) / 2 + Vector2(-200, 0)


func _on_pigeon_drag_requested(pigeon: Pigeon):
	select_pigeon(pigeon)
	start_drag()


func _on_egg_drag_requested(egg: Egg):
	var slot: int = egg_basket.take_egg(egg)

	drag_manager.start_drag(
		egg,
		egg_basket,
		slot
	)


func _on_incubator_egg_drag_requested(egg: Egg, slot: IncubatorSlot):
	drag_manager.start_drag(
		egg,
		slot
	)


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
		pigeon_inspector.update_labels()


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

	drag_manager.start_drag(
		selected_pigeon,
		selected_pigeon.cell
	)


func _on_drag_finished(context: DragContext):
	if context == null:
		return

	if context.dragged_object is Pigeon:
		_finish_pigeon_drag(context)

	elif context.dragged_object is Egg:
		_finish_egg_drag(context)


func _finish_pigeon_drag(context: DragContext):

	var pigeon := context.dragged_object as Pigeon
	var source := context.source_container as Cell

	var target := loft.get_hovered_cell()

	if target == null:
		source.set_pigeon(pigeon)

	elif target.is_empty():
		source.take_pigeon()
		target.set_pigeon(pigeon)

	else:
		swap(source, target)


func _finish_egg_drag(context: DragContext):
	var egg := context.dragged_object as Egg

	# 1. Проверяем инкубатор
	var slot := incubator.get_hovered_slot()
	
	if slot:
		if slot.is_empty():
			slot.put_egg(egg)
			return

	# 2. Проверяем корзину
	if egg_basket.hovered:
		egg_basket.add_egg_immediately(egg)
		return

	# 3. Если никуда не положили
	if context.source_container is EggBasket:
		egg_basket.add_egg_immediately(egg)
		return

	elif context.source_container is IncubatorSlot:
		var source := context.source_container as IncubatorSlot
		source.put_egg(egg)


func swap(a: Cell, b: Cell):
	var first = a.take_pigeon()
	var second = b.take_pigeon()

	a.set_pigeon(second)
	b.set_pigeon(first)


func collect_eggs(cell: Cell):
	for egg in cell.take_eggs():
		egg_basket.receive_egg(egg)
