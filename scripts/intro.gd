class_name Intro
extends CanvasLayer

signal finished
signal next_slide

@export var slides: Array[IntroSlide]
@export var transition_time := 1.5

@onready var slide: Control = $Slide
@onready var image: TextureRect = $Slide/TextureRect
@onready var text: RichTextLabel = $Slide/MarginContainer/Panel/MarginContainer/RichTextLabel
@onready var text_panel: Panel = $Slide/MarginContainer/Panel


var waiting := false


func _ready():
	hide()


func play():
	show()

	for data in slides:
		image.texture = data.image
		text.text = data.text
		
		await _show_slide(data.show_text)

		await _wait_for_next_slide(data.duration)

		await _hide_slide()

	hide()
	finished.emit()


func _show_slide(show_text: bool):
	slide.modulate.a = 0
	slide.position.y = 20

	var tween := create_tween()
	tween.set_parallel()

	tween.tween_property(
		slide,
		"modulate:a",
		1.0,
		transition_time
	)
	
	text_panel.visible = show_text

	tween.tween_property(
		slide,
		"position:y",
		0.0,
		transition_time
	)
	
	await tween.finished


func _hide_slide():
	var tween := create_tween()
	tween.set_parallel()

	tween.tween_property(
		slide,
		"modulate:a",
		0.0,
		transition_time
	)

	tween.tween_property(
		slide,
		"position:y",
		-20.0,
		transition_time
	)

	await tween.finished


func _wait_for_next_slide(duration: float):
	waiting = true

	var timer := get_tree().create_timer(duration)
	timer.timeout.connect(_on_slide_timeout)

	while waiting:
		await get_tree().process_frame


func _on_slide_timeout():
	waiting = false


func _input(event):
	if !visible or !waiting:
		return

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		waiting = false

	elif event.is_action_pressed("ui_accept"):
		waiting = false
