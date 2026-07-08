class_name PurchaseDialog
extends CanvasLayer

signal buy_pressed(offer: ShopOffer)
signal closed

var current_offer: ShopOffer

@onready var name_label = $Panel/NameLabel
@onready var price_label = $Panel/PriceLabel


func show_offer(offer: ShopOffer):
	current_offer = offer

	name_label.text = offer.title
	price_label.text = str(offer.price)

	show()


func _on_buy_button_pressed():
	buy_pressed.emit(current_offer)
	hide()


func _on_cancel_button_pressed():
	closed.emit()
	hide()
