class_name LocalizedLabel
extends Label

@export var text_key := ""


func _ready():
	update_translation()

func _notification(what):
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		update_translation()

func update_translation():
	if text != "":
		text = tr(text_key)
