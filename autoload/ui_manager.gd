extends Node

#signal warning_requested(text: String, duration: float)

@onready var warning_popup := $WarningPopup


func show_message(text: String, duration := 3.0):
	#warning_requested.emit(text, duration)
	warning_popup.show_message(text, duration)


func show_warning(text: String, duration := 3.0):
	#warning_requested.emit(text, duration)
	warning_popup.show_message(text, duration)
