class_name PurchaseDialog
extends CanvasLayer

signal buy_pressed(offer: ShopOffer)
signal closed

var current_offer: ShopOffer

@onready var question_label = $CenterContainer/Panel/MarginContainer/QuestionLabel
@onready var panel = $CenterContainer/Panel


func show_offer(
		offer: ShopOffer,
		world_position: Vector2
	):

	current_offer = offer
	
	question_label.text = "Ты действительно хочешь купить " + offer.title + " за " + str(offer.get_price()) + " грошей?"
	
	show()
	
	await get_tree().process_frame

	#var screen_position = world_position
	panel.position = world_position


func _on_buy_button_pressed():
	if current_offer == null:
		return

	buy_pressed.emit(current_offer)

	hide()


func _on_cancel_button_pressed() -> void:
	current_offer = null
	closed.emit()
	hide()
