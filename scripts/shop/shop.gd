class_name Shop
extends Node2D

signal farm_pressed

@export var shop_item_scene: PackedScene

@onready var item_points := $CounterPoints.get_children()
@onready var purchase_dialog: PurchaseDialog = $PurchaseDialog

var active: bool = false


func _ready():
	spawn_items()


func spawn_items():
	var offers := ShopCatalog.get_current_offers()

	for i in min(offers.size(), item_points.size()):
		var item := shop_item_scene.instantiate() as ShopItem

		add_child(item)

		item.position = item_points[i].position
		item.setup(offers[i])
		
		item.selected.connect(_on_item_selected)


func _on_item_selected(offer: ShopOffer):
	purchase_dialog.show_offer(offer)


func _on_back_button_pressed() -> void:
	farm_pressed.emit()


func set_active(value: bool):
	self.active = value
