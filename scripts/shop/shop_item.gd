class_name ShopItem
extends Area2D

signal selected(offer: ShopOffer)
#signal bought

@export var max_sprite_size := Vector2(256, 256)

var offer: ShopOffer = null

@onready var sprite: Sprite2D = $Sprite2D
@onready var price_label: Label = $PriceLabel


func setup(new_offer: ShopOffer):
	offer = new_offer

	sprite.texture = offer.icon
	price_label.text = str(offer.get_price())

	_fit_sprite()


func _input_event(
	_viewport: Node,
	event: InputEvent,
	_shape_idx: int
):
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		selected.emit(offer)


func _fit_sprite():
	if sprite.texture == null:
		return

	var size := sprite.texture.get_size()

	var scale_factor = min(
		max_sprite_size.x / size.x,
		max_sprite_size.y / size.y
	)

	sprite.scale = Vector2.ONE * scale_factor


func remove_from_shop():
	queue_free()
