class_name PigeonInspector
extends PanelContainer

signal sell_pressed

var pigeon: Pigeon

@onready var portrait: TextureRect = $MarginContainer/VBoxContainer/Portrait
@onready var nickname_edit : LineEdit = $MarginContainer/VBoxContainer/NicknameEdit
@onready var breed_label: Label = $MarginContainer/VBoxContainer/BreedLabel
@onready var age_label: Label = $MarginContainer/VBoxContainer/AgeLabel
@onready var price_label: Label = $MarginContainer/VBoxContainer/PriceLabel
@onready var generation_label: Label = $MarginContainer/VBoxContainer/GenerationLabel
@onready var eggs_counter_label: Label = $MarginContainer/VBoxContainer/EggsCounterLabel
@onready var interval_label: Label = $MarginContainer/VBoxContainer/IntervalLabel
@onready var sell_button: Button = $MarginContainer/VBoxContainer/SellButton


#func _ready():
	#hide()
	

func show_pigeon(new_pigeon: Pigeon):
	pigeon = new_pigeon
	
	var data := pigeon.data
	
	portrait.texture = data.sprite
	
	nickname_edit.text = data.nickname
	breed_label.text = "Порода: " + data.breed_name
	age_label.text = "Возраст: " + str(data.age)
	price_label.text = "Цена: " + str(data.price) + " грошей"
	eggs_counter_label.text = "Яиц снесено: " + str(data.eggs_laid)
	generation_label.text = "Поколение: " + str(data.generation)

	show()


func clear():
	hide()


func _on_sell_button_pressed() -> void:
	sell_pressed.emit()


func _on_nickname_edit_text_changed(new_text: String):
	if pigeon == null:
		return

	pigeon.data.nickname = new_text
