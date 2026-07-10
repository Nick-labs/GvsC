extends Node

#signal warning_requested(text: String, duration: float)

@onready var warning_popup := $MarginContainer/WarningPopup
@onready var clock_display := $MarginContainer/ClockDisplay


func show_message(text: String, duration := 3.0):
	#warning_requested.emit(text, duration)
	warning_popup.show_message(text, duration)


func show_warning(text: String, duration := 3.0):
	#warning_requested.emit(text, duration)
	warning_popup.show_message(text, duration)


func set_money(money: int):
	clock_display.set_money(money)


func hide_money():
	clock_display.monel_label.hide()


func show_money():
	clock_display.monel_label.show()
