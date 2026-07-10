class_name FoxAttackOverlay
extends CanvasLayer


func play():
	show()

	await get_tree().create_timer(5.0).timeout

	hide()
