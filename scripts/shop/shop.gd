class_name Shop
extends Node2D

signal farm_pressed

@export var catalog: ShopCatalog
@export var shop_item_scene: PackedScene

@onready var item_points := $CounterPoints.get_children()
@onready var purchase_dialog: PurchaseDialog = $PurchaseDialog
@onready var seller_point: Marker2D = $Shopkeeper/DialogPoint

var selected_item: ShopItem

var active: bool = false


func _ready():
	spawn_items()
	
	purchase_dialog.buy_pressed.connect(
		_on_buy_pressed
	)


func spawn_items():
	if catalog == null:
		print("Shop: каталог не задан")
		return
	
	clear_items()
	
	var offers: Array = catalog.get_current_offers()

	for i in min(offers.size(), item_points.size()):
		var item := shop_item_scene.instantiate() as ShopItem

		add_child(item)

		item.position = item_points[i].position
		item.setup(offers[i])
		
		item.selected.connect(
			_on_item_selected.bind(item)
		)


func clear_items():
	for child in get_children():
		if child is ShopItem:
			child.queue_free()


func _on_item_selected(offer: ShopOffer, item: ShopItem):
	selected_item = item
	purchase_dialog.show_offer(
		offer,
		seller_point.global_position
	)


func _on_back_button_pressed() -> void:
	farm_pressed.emit()


func _on_buy_pressed(offer: ShopOffer):
	var success := ShopManager.buy(offer)

	if success:
		print("Покупка успешна")
		if selected_item:
			selected_item.queue_free()
			selected_item = null
	else:
		print("Недостаточно денег")


func set_active(value: bool):
	active = value
	visible = value
	
	if value:
		selected_item = null
		refresh()
	else:
		purchase_dialog.hide()


func refresh():
	spawn_items()
