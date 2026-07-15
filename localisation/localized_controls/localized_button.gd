class_name LocalizedButton
extends Button


@export var text_key := ""

#@export var text_key := "":
	#set(value):
		#text_key = value
		#if Engine.is_editor_hint():
			#update_translation()


func _ready():
	update_translation()

func _notification(what):
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		update_translation()

func update_translation():
	if text != "":
		text = tr(text_key)
