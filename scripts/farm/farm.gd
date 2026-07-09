class_name Farm
extends Node2D

signal ready_ui(farm_ui)

@onready var loft: Loft = $Loft
@onready var egg_basket: EggBasket = $EggBasket
@onready var incubator: Incubator = $Incubator
@onready var farm_ui: FarmUI = $FarmUI
@onready var pigeon_inspector: PigeonInspector  = $FarmUI/MarginContainer/PigeonInspector
@onready var drag_manager: DragManager = $DragManager
@onready var camera: Camera2D = $Camera2D

var selected_pigeon: Pigeon = null
var music_started := false

var collecting := false

var active := true


func _ready() -> void:
	egg_basket.egg_drag_requested.connect(_on_egg_drag_requested)
	
	incubator.egg_drag_requested.connect(
		_on_incubator_egg_drag_requested
	)
	incubator.pigeon_drag_requested.connect(
		_on_incubator_pigeon_drag_requested
	)
	
	loft.pigeon_clicked.connect(_on_pigeon_clicked)
	loft.pigeon_drag_requested.connect(_on_pigeon_drag_requested)
	loft.pigeon_egg_laid.connect(_on_pigeon_egg_laid)
	
	drag_manager.drag_finished.connect(_on_drag_finished)
	
	pigeon_inspector.sell_pressed.connect(_on_sell_pressed)
	
	farm_ui.set_money(PlayerData.money)
	
	TimeManager.minute_passed.connect(_on_minute)
	
	ready_ui.emit(farm_ui)
	
	PlayerData.money_changed.connect(_on_money_changed)
	PlayerData.upgrades_changed.connect(_on_upgrades_changed)
	
	_on_upgrades_changed()
	
	farm_ui.set_money(PlayerData.money)


func _on_minute(day, hour, minute):
	pass
	#print(day, " ", hour, ":", minute)


func _input(event):
	if not active:
		return
	
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_RIGHT \
	and event.pressed:

		try_start_egg_drag()
		
	if event is InputEventMouseButton and \
	event.button_index == MOUSE_BUTTON_LEFT:
		
		collecting = event.pressed
		if !event.pressed:
			egg_basket.layout()
	
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


func _on_incubator_pigeon_drag_requested(
		pigeon: Pigeon,
		slot: IncubatorSlot
	):
	
	select_pigeon(pigeon)
	drag_manager.start_drag(
		pigeon,
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
	
	if selected_pigeon.cell != null:
		selected_pigeon.cell.remove_pigeon()
	
	for inc_slot in incubator.get_slots():
		if inc_slot.pigeon == selected_pigeon:
			inc_slot.clear()
	
	if PlayerData.backpack.add_pigeon(selected_pigeon.data):
		selected_pigeon.queue_free()
	
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
	
	if pigeon.cell != null:
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
	var source := context.source_container
	
	var target := loft.get_hovered_cell()

	if target == null:
		_return_pigeon(
			pigeon,
			source
		)

	elif target.is_empty():
		if source is Cell:
			source.take_pigeon()
		elif source is IncubatorSlot:
			source.take_pigeon()

		loft.setup_pigeon(pigeon)
		target.set_pigeon(pigeon)

	elif source is Cell:
		swap(source, target)
	else:
		_return_pigeon(
			pigeon,
			source
		)


func _return_pigeon(
		pigeon: Pigeon,
		source: Node
	):

	if source is Cell:
		source.set_pigeon(pigeon)

	elif source is IncubatorSlot:
		source.put_pigeon(pigeon)


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


# Здесь был баг с freed object, но я не смог его повторить
func collect_eggs(cell: Cell):
	for egg in cell.take_eggs():
		if !is_instance_valid(egg):
			push_error("Freed egg found!")
			continue

		egg_basket.receive_egg(egg)


func take_egg_to_backpack(egg: Egg):
	if PlayerData.add_egg(egg.data):
		egg_basket.take_egg(egg)
		egg.queue_free()


func take_pigeon_to_backpack(pigeon: Pigeon):
	if PlayerData.add_pigeon(pigeon.data):
		pigeon.cell.remove_pigeon()


func set_active(value: bool):
	active = value
	
	if value:
		camera.enabled = true
		camera.make_current()
	else:
		camera.enabled = false


func _on_money_changed(value: int):
	farm_ui.set_money(value)

func _on_upgrades_changed():
	loft.update_unlocked_cells()
	incubator.update_unlocked_slots()
