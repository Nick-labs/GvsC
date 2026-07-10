class_name FoxAttackOverlay
extends CanvasLayer


func play():
	show()
	AudioManager.play_music_by_name("defeat")
	await get_tree().create_timer(10.0).timeout
	
	hide()
