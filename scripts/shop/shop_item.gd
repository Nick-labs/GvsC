class_name ShopItem
extends Area2D

signal selected(offer: ShopOffer)

var offer: ShopOffer

@onready var sprite: Sprite2D = $Sprite2D
@onready var price_label: Label = $PriceLabel


func setup(new_offer: ShopOffer):
	offer = new_offer

	sprite.texture = offer.icon
	price_label.text = str(offer.price)


func _input_event(
	_viewport: Node,
	event: InputEvent,
	_shape_idx: int
):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		selected.emit(offer)
