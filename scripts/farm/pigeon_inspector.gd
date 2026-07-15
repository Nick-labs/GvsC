class_name PigeonInspector
extends PanelContainer

signal sell_pressed

var pigeon: Pigeon

@onready var content := $MarginContainer/VBoxContainer

@onready var portrait: TextureRect = $MarginContainer/VBoxContainer/Portrait

@onready var nickname_edit : LineEdit = $MarginContainer/VBoxContainer/HBoxContainer/NicknameEdit
@onready var nickname_label : Label = $MarginContainer/VBoxContainer/HBoxContainer/NicknameLabel

@onready var breed_label: Label = $MarginContainer/VBoxContainer/BreedLabel
#@onready var age_label: Label = $MarginContainer/VBoxContainer/AgeLabel
@onready var price_label: Label = $MarginContainer/VBoxContainer/PriceLabel
@onready var generation_label: Label = $MarginContainer/VBoxContainer/GenerationLabel

@onready var egg_portrait: TextureRect = $MarginContainer/VBoxContainer/EggContainer/EggPortrait
@onready var egg_label: Label = $MarginContainer/VBoxContainer/EggContainer/EggLabel

@onready var egg_price_label: Label = $MarginContainer/VBoxContainer/EggPriceLabel
@onready var interval_label: Label = $MarginContainer/VBoxContainer/IntervalLabel

@onready var eggs_counter_label: Label = $MarginContainer/VBoxContainer/EggsCounterLabel

@onready var sell_button: Button = $MarginContainer/VBoxContainer/SellButton


func _ready():
	nickname_edit.hide()
	nickname_label.hide()
	sell_button.hide()


func show_pigeon(new_pigeon: Pigeon):
	pigeon = new_pigeon
	
	var data := pigeon.data
	
	portrait.texture = data.sprite
	
	update_labels(data)
	
	content.show()
	
	nickname_edit.show()
	nickname_label.show()
	sell_button.show()


func update_labels(data: PigeonData):
	if data == null:
		return
	
	breed_label.text = tr("pigeon_inspector.breed") % data.breed_name_key

	price_label.text = tr("pigeon_inspector.price") % data.price

	generation_label.text = tr("pigeon_inspector.generation") % data.generation

	egg_price_label.text = tr("pigeon_inspector.egg_price")

	egg_portrait.texture = data.egg_template.texture
	egg_label.text = tr(data.egg_template.name_key)

	egg_price_label.text = tr("pigeon_inspector.egg_price") % data.egg_template.price

	interval_label.text = tr("pigeon_inspector.production_rate") % (
		60.0 / data.egg_interval_minutes
	)

	eggs_counter_label.text = tr("pigeon_inspector.eggs_produced") % data.eggs_laid


func clear():
	content.hide()


func _on_sell_button_pressed() -> void:
	sell_pressed.emit()


func _on_nickname_edit_text_changed(new_text: String):
	if pigeon == null:
		return

	pigeon.data.nickname = new_text


func _notification(what):
	if what == NOTIFICATION_TRANSLATION_CHANGED:
		if pigeon != null:
			update_labels(pigeon.data)
