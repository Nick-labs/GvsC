class_name WarningPopup
extends CanvasLayer

@onready var label: Label = $Panel/MarginContainer/Label
@onready var panel := $Panel


func show_message(text: String, duration := 3.0):
	label.text = text

	show()

	var tween := create_tween()

	panel.modulate.a = 0

	tween.tween_property(panel, "modulate:a", 1.0, 0.3)
	tween.tween_interval(duration)
	tween.tween_property(panel, "modulate:a", 0.0, 0.3)

	await tween.finished

	hide()
