class_name Intro
extends CanvasLayer

signal finished

@export var slides: Array[IntroSlide]

@onready var image = $TextureRect
@onready var text = $RichTextLabel
@onready var fade = $ColorRect


func play():
	show()

	fade.color.a = 1

	for slide in slides:
		image.texture = slide.image
		text.text = slide.text

		await _fade_in()

		await get_tree().create_timer(
			slide.duration
		).timeout

		await _fade_out()

	hide()

	finished.emit()


func _fade_in():
	var tween = create_tween()

	tween.tween_property(
		fade,
		"color:a",
		0.0,
		1.0
	)

	await tween.finished


func _fade_out():
	var tween = create_tween()

	tween.tween_property(
		fade,
		"color:a",
		1.0,
		1.0
	)

	await tween.finished
